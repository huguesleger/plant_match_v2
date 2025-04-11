import 'dart:io';

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

  Future<void> createCatalog(Catalog catalog) async {
    try {
      emit(CatalogLoading());

      await catalogRepository.createCatalog(catalog);

      emit(CatalogLoaded(catalog));
    } catch (e) {
      emit(CatalogError(e.toString()));
    }
  }

  Future<void> uploadImagesToCatalog(
      String userId, String catalogId, List<String> imagePaths) async {
    emit(CatalogLoading());
    try {
      List<String> imageUrls = [];
      for (String imagePath in imagePaths) {
        File file = File(imagePath);
        await storageRepository.uploadImageFromUrl(
          path: file.path,
          fileName: '${userId}_${file.path.split('/').last}',
          folder: 'catalog_images',
        );
      }
    } catch (e) {
      emit(CatalogError("Erreur lors du téléchargement des images"));
    }
  }

  Future<void> getCatalog(String catalogUid) async {
    try {
      emit(CatalogLoading());

      // Récupérer le catalogue via le repository
      final catalog = await catalogRepository.getCatalog(catalogUid);

      if (catalog != null) {
        // Si le catalogue existe, émettre un état de chargement réussi avec le catalogue
        emit(CatalogLoaded(catalog));
      } else {
        final newCatalog = Catalog(
          uid: catalogUid,
          name: catalog?.name ?? "",
          description: catalog?.description ?? "",
          images: catalog?.images ?? [],
          environment: catalog?.environment ?? Environment.indoor,
          family: catalog?.family ?? Family.flower,
          levelMaintenance: catalog?.levelMaintenance ?? LevelMaintenance.low,
          watering: catalog?.watering ?? Watering.little,
          lighting: catalog?.lighting ?? Lighting.indirectLight,
        );
        await catalogRepository.createCatalog(newCatalog);
        emit(CatalogLoaded(newCatalog));
      }
    } catch (e) {
      emit(CatalogError("Erreur lors de la récupération du catalogue: $e"));
    }
  }

  Future<void> updateCatalog({
    required String catalogId,
    String? newName,
    Environment? newEnvironment,
    Family? newFamily,
    LevelMaintenance? newLevelMaintenance,
    Watering? newWatering,
    Lighting? newLighting,
    String? newDescription,
    List<String>? images,
  }) async {
    emit(CatalogLoading());

    try {
      // Récupérer le catalogue actuel
      final currentCatalog = await catalogRepository.getCatalog(catalogId);

      if (currentCatalog == null) {
        emit(CatalogError("Catalogue introuvable"));
        return;
      }

/*      if (images != null && images.isNotEmpty) {
        List<String> uploadedImageUrls = [];
        for (String imagePath in images) {
          String? imageUrl = await storageRepository.uploadImageFromUrl(
            path: imagePath,
            fileName: "$catalogId${imagePath.split('/').last}",
            folder: 'catalog_images',
          );
          if (imageUrl != null) {
            uploadedImageUrls.add(imageUrl);
          }
        }
      }*/
      List<String>? uploadedImageUrls = [];

      if (images != null) {
        for (String imagePath in images) {
          String? imageUrl = await storageRepository.uploadImageFromUrl(
            path: imagePath, // Passer le chemin local
            fileName: "$catalogId${imagePath.split('/').last}", // Nom unique
            folder: 'catalog_images',
          );

          if (imageUrl != null) {
            uploadedImageUrls.add(imageUrl); // Stocker l'URL Firebase
          }
        }
      }

      // Créer une copie mise à jour
      final updatedCatalog = currentCatalog.copyWith(
        newName: newName ?? currentCatalog.name,
        newEnvironment: newEnvironment ?? currentCatalog.environment,
        newFamily: newFamily ?? currentCatalog.family,
        newLevelMaintenance:
            newLevelMaintenance ?? currentCatalog.levelMaintenance,
        newWatering: newWatering ?? currentCatalog.watering,
        newLighting: newLighting ?? currentCatalog.lighting,
        newDescription: newDescription ?? currentCatalog.description,
        //newImages: uploadedImageUrls ?? currentCatalog.images,
      );

      // Mettre à jour dans Firebase
      await catalogRepository.updateCatalog(updatedCatalog);

      // Recharger et émettre l'état mis à jour
      final refreshedCatalog = await catalogRepository.getCatalog(catalogId);
      emit(CatalogLoaded(refreshedCatalog!));
    } catch (e) {
      emit(CatalogError("Erreur lors de la mise à jour du catalogue: $e"));
    }
  }

  Future<void> saveCatalog(Catalog catalog) async {
    emit(CatalogLoading());
    try {
      final existingCatalog = await catalogRepository.getCatalog(catalog.uid);

      if (existingCatalog == null) {
        await catalogRepository.createCatalog(catalog);
      } else {
        print("🚀 Envoi à Firebase: ${catalog.toJson()}");
        print("🚀 Sauvegarde Firebase : ${catalog.images}");
        // Si le catalogue existe déjà, mets-le à jour avec le nouveau nom (ou d'autres champs)
        await catalogRepository.updateCatalog(catalog);
      }

      emit(CatalogLoaded(catalog));
    } catch (e) {
      emit(CatalogError('Erreur lors de l\'enregistrement du catalogue : $e'));
    }
  }

  Future<void> updateImageCatalog(
      String catalogId, List<File> selectedImages) async {
    emit(CatalogLoading());

    try {
      final currentCatalog = await catalogRepository.getCatalog(catalogId);
      if (currentCatalog == null) {
        emit(CatalogError("Catalogue introuvable"));
        return;
      }

      List<String> uploadedImageUrls = [];

      for (File imageFile in selectedImages) {
        print("📤 Uploading image: ${imageFile.path}");

        String? imageUrl = await storageRepository.uploadImageFromUrl(
          path: imageFile.path,
          fileName: "$catalogId${imageFile.path.split('/').last}",
          folder: 'catalog_images',
        );

        if (imageUrl != null) {
          uploadedImageUrls.add(imageUrl);
          print("✅ Uploaded: $imageUrl");
        } else {
          print("❌ Upload failed for ${imageFile.path}");
        }
      }

      // Récupérer les anciennes images déjà stockées sur Firebase
      List<String> existingImages = currentCatalog.images ?? [];

      // Ajouter les nouvelles images aux anciennes
      List<String> updatedImages = [...existingImages, ...uploadedImageUrls];

      print("🔍 Final image list: $updatedImages");

      await catalogRepository.updateImageCatalog(catalogId, updatedImages);

      final refreshedCatalog = await catalogRepository.getCatalog(catalogId);
      emit(refreshedCatalog != null
          ? CatalogLoaded(refreshedCatalog)
          : CatalogError("Erreur de récupération"));
    } catch (e) {
      emit(CatalogError("Erreur lors de l'upload des images: $e"));
    }
  }
}
