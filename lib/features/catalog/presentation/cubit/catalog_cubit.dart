import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/domain/repository/catalog_repository.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_state.dart';
import 'package:plant_match_v2/features/storage/domain/storage_repository.dart';

class CatalogCubit extends Cubit<CatalogState> {
  final CatalogRepository catalogRepository;
  final StorageRepository storageRepository;

  CatalogCubit({
    required this.catalogRepository,
    required this.storageRepository,
  }) : super(const CatalogInitial());

  // ─── getCatalogsByUserId ───────────────────────────────────────────────────

  void getCatalogsByUserId(String userId) {
    emit(const CatalogLoading());

    catalogRepository
        .getCatalogsByUserId(userId)
        .flatMap((catalogs) => catalogRepository.getCatalogById(userId).map(
              (option) => option.match(
                () => CatalogLoaded(catalogs, Catalog.empty(userId)),
                (catalog) => CatalogLoaded(catalogs, catalog),
              ),
            ))
        .match(
          (failure) => CatalogError(failure.message),
          (state) => state,
        )
        .map(emit)
        .run();
  }

  // ─── addCatalog ────────────────────────────────────────────────────────────

  TaskEither<Failure, (String, bool)> addCatalog(Catalog catalog) {
    emit(const CatalogLoading());

    return catalogRepository.createCatalog(catalog).flatMap((id) {
      final updatedCatalog = catalog.copyWith(newCatalogId: id);
      return catalogRepository
          .getCatalogsByUserId(catalog.userId)
          .flatMap((catalogs) {
        final isFirstPlant = catalogs.length == 1;
        return TaskEither<Failure, (String, bool)>.tryCatch(
          () async {
            emit(CatalogLoaded(catalogs, updatedCatalog));
            return (id, isFirstPlant);
          },
          (error, _) => UnexpectedFailure(error.toString()),
        );
      });
    });
  }

  // ─── updateCatalog ─────────────────────────────────────────────────────────

  void updateCatalog(Catalog catalog) {
    emit(const CatalogLoading());

    catalogRepository
        .updateCatalog(catalog)
        .flatMap((_) => catalogRepository.getCatalogsByUserId(catalog.userId))
        .match(
          (failure) => CatalogError(failure.message),
          (catalogs) => CatalogLoaded(catalogs, catalog),
        )
        .map(emit)
        .run();
  }

  // ─── editCatalog ───────────────────────────────────────────────────────────

  void editCatalog(Catalog catalog) {
    emit(const CatalogLoading());

    catalogRepository
        .updateCatalog(catalog)
        .flatMap((_) => catalogRepository.getCatalogsByUserId(catalog.userId))
        .match(
          (failure) => CatalogError(failure.message),
          (catalogs) => CatalogLoaded(catalogs, catalog),
        )
        .map(emit)
        .run();
  }

  // ─── uploadCatalogImages ───────────────────────────────────────────────────

  TaskEither<Failure, Catalog> uploadCatalogImages({
    required Catalog catalog,
    required List<String> imagePaths,
    required String catalogId,
    required List<String> existingImages,
  }) {
    emit(const CatalogLoading());

    final uploadTasks = imagePaths.map((imagePath) {
      final fileName = "${catalogId}_${imagePath.split('/').last}";
      return storageRepository.uploadImageFromUrl(
        path: imagePath,
        fileName: fileName,
        folder: 'catalog_images',
      );
    }).toList();

    return TaskEither.sequenceList(uploadTasks).flatMap((uploadedUrls) {
      final newImageList = [...existingImages, ...uploadedUrls];
      final updatedCatalog = catalog.copyWith(
        newCatalogId: catalogId,
        newImages: newImageList,
      );

      return catalogRepository
          .updateCatalog(updatedCatalog)
          .flatMap((_) => catalogRepository.getCatalogsByUserId(catalog.userId))
          .flatMap((catalogs) {
        return TaskEither<Failure, Catalog>.tryCatch(
          () async {
            emit(CatalogLoaded(catalogs, updatedCatalog));
            return updatedCatalog;
          },
          (error, _) => UnexpectedFailure(error.toString()),
        );
      });
    });
  }

  // ─── deleteImageCatalog ────────────────────────────────────────────────────

  TaskEither<Failure, Catalog> deleteImageCatalog({
    required Catalog catalog,
    required String imageUrl,
  }) {
    emit(const CatalogLoading());

    return storageRepository.deleteImage(imageUrl: imageUrl).flatMap((_) {
      final updatedImages =
          catalog.images.where((img) => img != imageUrl).toList();
      final updatedCatalog = catalog.copyWith(newImages: updatedImages);

      return catalogRepository
          .updateCatalog(updatedCatalog)
          .flatMap((_) => catalogRepository.getCatalogsByUserId(catalog.userId))
          .flatMap((catalogs) {
        return TaskEither<Failure, Catalog>.tryCatch(
          () async {
            emit(CatalogLoaded(catalogs, updatedCatalog));
            return updatedCatalog;
          },
          (error, _) => UnexpectedFailure(error.toString()),
        );
      });
    });
  }

  // ─── getCatalogById ────────────────────────────────────────────────────────

  TaskEither<Failure, Catalog> getCatalogById(String catalogId) {
    emit(const CatalogLoading());

    return catalogRepository.getCatalogById(catalogId).flatMap((option) =>
        option.match(
          () => TaskEither.left(const FirebaseFailure("Catalogue non trouvé")),
          (catalog) {
            return TaskEither<Failure, Catalog>.tryCatch(
              () async {
                emit(CatalogLoaded([catalog], catalog));
                return catalog;
              },
              (error, _) => UnexpectedFailure(error.toString()),
            );
          },
        ));
  }

  // ─── deleteCatalog ─────────────────────────────────────────────────────────

  TaskEither<Failure, int> deleteCatalog(String catalogId, String userId) {
    emit(const CatalogLoading());

    return catalogRepository.deleteCatalog(catalogId).flatMap((_) {
      return catalogRepository.getCatalogsByUserId(userId).flatMap((catalogs) {
        return TaskEither<Failure, int>.tryCatch(
          () async {
            emit(CatalogLoaded(catalogs, Catalog.empty(userId)));
            return catalogs.length;
          },
          (error, stackTrace) => UnexpectedFailure(error.toString()),
        );
      });
    });
  }
}
