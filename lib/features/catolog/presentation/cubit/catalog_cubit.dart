import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catolog/domain/repository/catalog_repository.dart';
import 'package:plant_match_v2/features/catolog/presentation/cubit/catalog_state.dart';
import 'package:plant_match_v2/features/storage/domain/storage_repository.dart';

class CatalogCubit extends Cubit<CatalogState> {
  final CatalogRepository catalogRepository;
  final StorageRepository storageRepository;

  CatalogCubit(
      {required this.catalogRepository, required this.storageRepository})
      : super(CatalogInitial());

  Future<void> getCatalogsByUserId(String userId) async {
    emit(CatalogLoading());
    try {
      final catalogs = await catalogRepository.getCatalogsByUserId(userId);
      final catalog = await catalogRepository.getCatalogById(userId);
      if (catalog == null) {
        final catalogEmpty = Catalog(
          userId: userId,
          name: '',
          description: '',
          images: [],
          environment: Environment.indoor,
          family: [Family.flower],
          levelMaintenance: LevelMaintenance.low,
          watering: Watering.little,
          lighting: Lighting.sun,
          isPublish: false,
          createdAt: DateTime.now(),
          offerType: OfferType.exchange,
        );
        return emit(CatalogLoaded(catalogs, catalogEmpty));
      }
      emit(CatalogLoaded(catalogs, catalog));
    } catch (e) {
      emit(CatalogError("Erreur chargement : $e"));
    }
  }

  Future<String> addCatalog(Catalog catalog) async {
    emit(CatalogLoading());
    try {
      final id = await catalogRepository.createCatalog(catalog);
      final catalogs =
          await catalogRepository.getCatalogsByUserId(catalog.userId);
      emit(CatalogLoaded(catalogs, catalog.copyWith(newCatalogId: id)));
      return id;
    } catch (e) {
      emit(CatalogError("Erreur ajout : $e"));
      rethrow;
    }
  }

  Future<void> updateCatalog(Catalog catalog) async {
    emit(CatalogLoading());
    try {
      await catalogRepository.updateCatalog(catalog);
      final catalogs =
          await catalogRepository.getCatalogsByUserId(catalog.userId);
      emit(CatalogLoaded(catalogs, catalog));
    } catch (e) {
      emit(CatalogError("Erreur mise à jour : $e"));
    }
  }

  Future<void> editCatalog(Catalog catalog) async {
    emit(CatalogLoading());
    try {
      await catalogRepository.updateCatalog(catalog);

      final catalogs =
          await catalogRepository.getCatalogsByUserId(catalog.userId);
      emit(CatalogLoaded(catalogs, catalog));
    } catch (e) {
      emit(CatalogError("Erreur lors de la modification : $e"));
    }
  }

  Future<Catalog?> uploadCatalogImages({
    required Catalog catalog,
    required List<String> imagePaths,
    required String catalogId,
    required List<String> existingImages,
  }) async {
    emit(CatalogLoading());
    try {
      final List<String> uploadedUrls = [];

      for (final imagePath in imagePaths) {
        final fileName = "${catalogId}_${imagePath.split('/').last}";

        final imageUrl = await storageRepository.uploadImageFromUrl(
          path: imagePath,
          fileName: fileName,
          folder: 'catalog_images',
        );

        if (imageUrl != null) {
          uploadedUrls.add(imageUrl);
        }
      }

      final newImageList = [...existingImages, ...uploadedUrls];

      final updatedCatalog = catalog.copyWith(
        newCatalogId: catalogId,
        newImages: newImageList,
      );

      await catalogRepository.updateCatalog(updatedCatalog);

      final catalogs =
          await catalogRepository.getCatalogsByUserId(catalog.userId);
      emit(CatalogLoaded(catalogs, updatedCatalog));

      return updatedCatalog;
    } catch (e) {
      emit(CatalogError("Erreur upload d’images : $e"));
      return null;
    }
  }

  Future<Catalog?> deleteImageCatalog({
    required Catalog catalog,
    required String imageUrl,
  }) async {
    emit(CatalogLoading());

    try {
      await storageRepository.deleteImage(imageUrl: imageUrl);
      final updatedImages =
          catalog.images.where((img) => img != imageUrl).toList();
      final updatedCatalog = catalog.copyWith(newImages: updatedImages);
      await catalogRepository.updateCatalog(updatedCatalog);
      final catalogs =
          await catalogRepository.getCatalogsByUserId(catalog.userId);

      emit(CatalogLoaded(catalogs, updatedCatalog));

      return updatedCatalog;
    } catch (e) {
      emit(CatalogError("Erreur suppression d’image : $e"));
      return null;
    }
  }

  Future<Catalog?> getCatalogById(String catalogId) async {
    emit(CatalogLoading());
    try {
      final catalog = await catalogRepository.getCatalogById(catalogId);
      if (catalog == null) {
        emit(CatalogError("Catalogue non trouvé"));
        return null;
      }
      emit(CatalogLoaded([catalog], catalog));
      return catalog;
    } catch (e) {
      emit(CatalogError("Erreur chargement du catalogue : $e"));
      return null;
    }
  }

  Future<void> deleteCatalog(String catalogId, String userId) async {
    emit(CatalogLoading());
    try {
      await catalogRepository.deleteCatalog(catalogId);
      final catalogs = await catalogRepository.getCatalogsByUserId(userId);
      emit(CatalogLoaded(catalogs, Catalog.empty(userId)));
    } catch (e) {
      emit(CatalogError("Erreur suppression : $e"));
    }
  }
}
