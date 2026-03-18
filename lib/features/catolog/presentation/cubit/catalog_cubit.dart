import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catolog/domain/repository/catalog_repository.dart';
import 'package:plant_match_v2/features/catolog/presentation/cubit/catalog_state.dart';
import 'package:plant_match_v2/features/storage/domain/storage_repository.dart';

class CatalogCubit extends Cubit<CatalogState> {
  final CatalogRepository catalogRepository;
  final StorageRepository storageRepository;

  CatalogCubit({
    required this.catalogRepository,
    required this.storageRepository,
  }) : super(CatalogInitial());

  // ─── getCatalogsByUserId ───────────────────────────────────────────────────

  void getCatalogsByUserId(String userId) {
    emit(CatalogLoading());

    catalogRepository
        .getCatalogsByUserId(userId)
        .flatMap((catalogs) => catalogRepository.getCatalogById(userId).map(
              (option) => option.match(
                () => CatalogLoaded(catalogs, Catalog.empty(userId)),
                (catalog) => CatalogLoaded(catalogs, catalog),
              ),
            ))
        .run()
        .then((result) => result.match(
              (failure) => emit(CatalogError(failure.message)),
              (state) => emit(state),
            ));
  }

  // ─── addCatalog ────────────────────────────────────────────────────────────

  TaskEither<Failure, String> addCatalog(Catalog catalog) {
    emit(CatalogLoading());

    return catalogRepository
        .createCatalog(catalog)
        .flatMap((id) => catalogRepository
            .getCatalogsByUserId(catalog.userId)
            .map((catalogs) {
          emit(CatalogLoaded(catalogs, catalog.copyWith(newCatalogId: id)));
          return id;
        }));
  }

  // ─── updateCatalog ─────────────────────────────────────────────────────────

  void updateCatalog(Catalog catalog) {
    emit(CatalogLoading());

    catalogRepository
        .updateCatalog(catalog)
        .flatMap((_) => catalogRepository.getCatalogsByUserId(catalog.userId))
        .run()
        .then((result) => result.match(
              (failure) => emit(CatalogError(failure.message)),
              (catalogs) => emit(CatalogLoaded(catalogs, catalog)),
            ));
  }

  // ─── editCatalog ───────────────────────────────────────────────────────────

  void editCatalog(Catalog catalog) {
    emit(CatalogLoading());

    catalogRepository
        .updateCatalog(catalog)
        .flatMap((_) => catalogRepository.getCatalogsByUserId(catalog.userId))
        .run()
        .then((result) => result.match(
              (failure) => emit(CatalogError(failure.message)),
              (catalogs) => emit(CatalogLoaded(catalogs, catalog)),
            ));
  }

  // ─── uploadCatalogImages ───────────────────────────────────────────────────

  TaskEither<Failure, Catalog> uploadCatalogImages({
    required Catalog catalog,
    required List<String> imagePaths,
    required String catalogId,
    required List<String> existingImages,
  }) {
    emit(CatalogLoading());

    // Utilisation de traverse pour uploader plusieurs images
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
          .map((catalogs) {
        emit(CatalogLoaded(catalogs, updatedCatalog));
        return updatedCatalog;
      });
    });
  }

  // ─── deleteImageCatalog ────────────────────────────────────────────────────

  TaskEither<Failure, Catalog> deleteImageCatalog({
    required Catalog catalog,
    required String imageUrl,
  }) {
    emit(CatalogLoading());

    return storageRepository.deleteImage(imageUrl: imageUrl).flatMap((_) {
      final updatedImages =
          catalog.images.where((img) => img != imageUrl).toList();
      final updatedCatalog = catalog.copyWith(newImages: updatedImages);

      return catalogRepository
          .updateCatalog(updatedCatalog)
          .flatMap((_) => catalogRepository.getCatalogsByUserId(catalog.userId))
          .map((catalogs) {
        emit(CatalogLoaded(catalogs, updatedCatalog));
        return updatedCatalog;
      });
    });
  }

  // ─── getCatalogById ────────────────────────────────────────────────────────

  TaskEither<Failure, Catalog> getCatalogById(String catalogId) {
    emit(CatalogLoading());

    return catalogRepository.getCatalogById(catalogId).flatMap((option) =>
        option.match(
          () => TaskEither.left(const FirebaseFailure("Catalogue non trouvé")),
          (catalog) {
            emit(CatalogLoaded([catalog], catalog));
            return TaskEither.right(catalog);
          },
        ));
  }

  // ─── deleteCatalog ─────────────────────────────────────────────────────────

  void deleteCatalog(String catalogId, String userId) {
    emit(CatalogLoading());

    catalogRepository
        .deleteCatalog(catalogId)
        .flatMap((_) => catalogRepository.getCatalogsByUserId(userId))
        .run()
        .then((result) => result.match(
              (failure) => emit(CatalogError(failure.message)),
              (catalogs) => emit(CatalogLoaded(catalogs, Catalog.empty(userId))),
            ));
  }
}
