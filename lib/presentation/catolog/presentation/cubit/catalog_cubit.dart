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

  Future<void> createEmptyCatalog(String userId) async {
    emit(CatalogLoading());
    try {
      final uid = await catalogRepository.createEmptyCatalog(userId);
      final catalog = await catalogRepository.getCatalogById(uid);
      if (catalog != null) {
        emit(CatalogLoaded([catalog]));
      } else {
        emit(CatalogError("Erreur: création échouée"));
      }
    } catch (e) {
      emit(CatalogError("Erreur création : $e"));
    }
  }

  Future<void> updateCatalog(Catalog updated) async {
    emit(CatalogLoading());
    try {
      await catalogRepository.updateCatalog(updated);
      final fullCatalog = await catalogRepository.getCatalogById(updated.uid);
      if (fullCatalog != null) {
        final currentState = state;
        if (currentState is CatalogLoaded) {
          final updatedList = currentState.catalogs.map((c) {
            return c.uid == updated.uid ? fullCatalog : c;
          }).toList();
          emit(CatalogLoaded(updatedList));
        } else {
          emit(CatalogLoaded([fullCatalog]));
        }
      } else {
        emit(CatalogError("Mise à jour échouée"));
      }
    } catch (e) {
      emit(CatalogError("Erreur mise à jour : $e"));
    }
  }

  Future<void> loadUserCatalogs(String userId) async {
    emit(CatalogLoading());
    try {
      final catalogs = await catalogRepository.getCatalogsByUserId(userId);
      emit(CatalogLoaded(catalogs));
    } catch (e) {
      emit(CatalogError("Erreur chargement : $e"));
    }
  }

  Future<void> uploadImagesToCatalog(
      String userId, String catalogId, List<String> imagePaths) async {
    emit(CatalogLoading());

    try {
      // 🔍 Récupère le catalogue actuel
      final catalog = await catalogRepository.getCatalogById(catalogId);
      if (catalog == null) {
        emit(CatalogError("Catalogue non trouvé"));
        return;
      }

      // 🔼 Upload des nouvelles images
      List<String> newImageUrls = [];
      for (String imagePath in imagePaths) {
        final imageUrl = await storageRepository.uploadImageFromUrl(
          path: imagePath,
          fileName: "$catalogId${imagePath.split('/').last}",
          folder: 'catalog_images',
        );
        if (imageUrl != null) {
          newImageUrls.add(imageUrl);
        }
      }

      // 🧠 Fusionne sans doublons avec les anciennes images
      final updatedImageList = {
        ...catalog.images,
        ...newImageUrls,
      }.toList();

      // 🔄 Met à jour le catalogue
      final updatedCatalog = catalog.copyWith(images: updatedImageList);
      await catalogRepository.updateCatalog(updatedCatalog);

      // 📥 Recharge depuis la source (si besoin pour la cohérence)
      final refreshedCatalog =
          await catalogRepository.getCatalogById(catalogId);
      if (refreshedCatalog == null) {
        emit(CatalogError("Échec de la récupération du catalogue mis à jour"));
        return;
      }

      // 📢 Mets à jour l’état global
      final currentState = state;
      if (currentState is CatalogLoaded) {
        final updatedList = currentState.catalogs.map((c) {
          return c.uid == catalogId ? refreshedCatalog : c;
        }).toList();
        emit(CatalogLoaded(updatedList));
      } else {
        emit(CatalogLoaded([refreshedCatalog]));
      }
    } catch (e, stack) {
      emit(CatalogError("Erreur lors du téléchargement des images : $e"));
    }
  }
}
