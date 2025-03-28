import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/presentation/catolog/domain/repository/catalog_repository.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/cubit/catalog_state.dart';
import 'package:plant_match_v2/presentation/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/presentation/profil/domain/repository/profil_repository.dart';
import 'package:plant_match_v2/presentation/storage/domain/storage_repository.dart';

class CatalogCubit extends Cubit<CatalogState> {
  final CatalogRepository catalogRepository;
  final StorageRepository storageRepository;

  CatalogCubit({
    required this.catalogRepository,
    required this.storageRepository,
  }) : super(CatalogInitial());

  Future<void> fetchCatalogs(String userId) async {
    emit(CatalogLoading());
    try {
      final catalogs = await catalogRepository.fetchCatalogs(userId);
      emit(CatalogLoaded(catalogs));
    } catch (e) {
      emit(CatalogError('Erreur lors du chargement des catalogues'));
    }
  }

  Future<void> addCatalog(Catalog catalog, String userId) async {
    try {
      await catalogRepository.addCatalog(catalog);
      fetchCatalogs(userId);
    } catch (e) {
      emit(CatalogError('Erreur lors de l’ajout du catalogue'));
    }
  }

/*  Future<void> addImageToCatalog(Catalog catalog, String userId) async {
    try {
      await storageRepository.uploadImageFromUrl(
        path: catalog.image,
        fileName: catalog.uid,
        folder: 'catalog_images',
      );
      fetchCatalogs(userId);
    } catch (e) {
      emit(CatalogError('Erreur lors de l’ajout de l’image au catalogue'));
    }
  }*/

  Future<void> uploadImagesToCatalog(
      String userId, List<String> imagePaths) async {
    try {
      for (String imagePath in imagePaths) {
        File file = File(imagePath);
        await storageRepository.uploadImageFromUrl(
          //path: 'catalog_images/$userId/${file.path.split('/').last}',
          path: file.path,
          fileName: '${userId}_${file.path.split('/').last}',
          //fileName: file.path.split('/').last,
          folder: 'catalog_images',
        );
      }

      fetchCatalogs(userId); // Rafraîchir la liste après upload
    } catch (e) {
      emit(CatalogError("Erreur lors de l'upload des images"));
    }
  }

  Future<void> deleteImageFromCatalog(String imageUrl, String userId) async {
    try {
      Reference ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
      fetchCatalogs(userId); // Rafraîchir les catalogues
    } catch (e) {
      emit(CatalogError('Erreur lors de la suppression de l’image'));
    }
  }

  Future<void> saveCatalog(Catalog catalog) async {
    emit(CatalogLoading());
    try {
      final existingCatalogs =
          await catalogRepository.fetchCatalogs(catalog.uid);
      if (existingCatalogs.any((element) => element.uid == catalog.uid)) {
        //await catalogRepository.updateCatalog(catalog);
      } else {
        await catalogRepository.addCatalog(catalog);
        emit(CatalogLoaded(existingCatalogs));
      }
      fetchCatalogs(catalog.uid);
    } catch (e) {
      emit(CatalogError('Erreur lors de la sauvegarde du catalogue'));
    }
  }
}
