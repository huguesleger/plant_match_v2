import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/presentation/catolog/domain/repository/catalog_repository.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/cubit/catalog_state.dart';

class CatalogCubit extends Cubit<CatalogState> {
  final CatalogRepository catalogRepository;

  CatalogCubit({required this.catalogRepository}) : super(CatalogInitial());

  Future<String> createCatalog(Catalog catalog, String userId) async {
    emit(CatalogLoading());
    try {
      final generatedId = await catalogRepository.createCatalog(catalog);
      await getUserCatalogs(userId); // refresh
      return generatedId;
    } catch (e) {
      emit(CatalogError('Erreur lors de la création du catalogue : $e'));
      rethrow;
    }
  }

  Future<void> getUserCatalogs(String userId) async {
    emit(CatalogLoading());
    try {
      final catalogs = await catalogRepository.getUserCatalogs(userId);
      emit(CatalogLoaded(catalogs));
    } catch (e) {
      emit(CatalogError('Erreur lors du chargement des catalogues : $e'));
    }
  }

  Future<void> saveCatalog(Catalog catalog) async {
    emit(CatalogLoading());
    try {
      if (catalog.uid.isEmpty) {
        // Si l'UID est vide, on crée un nouveau catalogue
        final generatedId = await catalogRepository.createCatalog(catalog);
        await getUserCatalogs(catalog
            .userId); // Mettre à jour la liste des catalogues de l'utilisateur
      } else {
        // Vérifie si le catalogue existe déjà avec cet UID
        final existingCatalog =
            await catalogRepository.getCatalogById(catalog.uid);

        if (existingCatalog != null) {
          // Si le catalogue existe, on le met à jour
          await catalogRepository.updateCatalog(catalog);
          await getUserCatalogs(catalog.userId);
        } else {
          // Si le catalogue n'existe pas, on le crée
          final generatedId = await catalogRepository.createCatalog(catalog);
          await getUserCatalogs(catalog.userId);
          catalog = catalog.copyWith(uid: generatedId);
        }
      }
    } catch (e) {
      emit(CatalogError('Erreur lors de l\'enregistrement du catalogue : $e'));
    }
  }

  Future<void> deleteCatalog(String uid, String userId) async {
    emit(CatalogLoading());
    try {
      await catalogRepository.deleteCatalog(uid);
      await getUserCatalogs(userId);
    } catch (e) {
      emit(CatalogError('Erreur lors de la suppression du catalogue : $e'));
    }
  }

  Future<void> clearCatalogField({
    required String uid,
    required String userId,
    required String fieldName,
  }) async {
    emit(CatalogLoading());
    try {
      final currentCatalog = await catalogRepository.getCatalogById(uid);
      if (currentCatalog == null) {
        emit(CatalogError('Catalogue introuvable'));
        return;
      }

      final updatedCatalog = currentCatalog.copyWith(
        name: fieldName == 'name' ? '' : null,
        description: fieldName == 'description' ? '' : null,
        image: fieldName == 'image' ? '' : null,
      );

      await catalogRepository.updateCatalog(updatedCatalog);
      await getUserCatalogs(userId);
    } catch (e) {
      emit(CatalogError('Erreur lors de la réinitialisation du champ : $e'));
    }
  }
}
