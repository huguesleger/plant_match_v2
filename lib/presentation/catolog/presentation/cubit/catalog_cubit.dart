import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/presentation/catolog/domain/repository/catalog_repository.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/cubit/catalog_state.dart';
import 'package:plant_match_v2/presentation/storage/domain/storage_repository.dart';

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

  Future<Catalog?> uploadCatalogImages({
    required Catalog catalog,
    required List<String> imagePaths,
    required String catalogId,
  }) async {
    emit(CatalogLoading());
    try {
      final List<String> uploadedUrls = [];

      // On vérifie si les images sont déjà présentes dans catalog.images
      for (final imagePath in imagePaths) {
        final fileName = "${catalogId}_${imagePath.split('/').last}";

        // Si l'image est déjà dans le catalogue, on ne l'upload pas à nouveau
        if (!catalog.images.contains(imagePath)) {
          final imageUrl = await storageRepository.uploadImageFromUrl(
            path: imagePath,
            fileName: fileName,
            folder: 'catalog_images',
          );
          if (imageUrl != null) {
            uploadedUrls.add(imageUrl);
          }
        }
      }

      // Mettre à jour le catalogue avec les nouvelles images
      final updatedCatalog = catalog.copyWith(
        newCatalogId: catalogId,
        newImages: [
          ...catalog.images,
          ...uploadedUrls
        ], // N'ajoute que les nouvelles images
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
}
