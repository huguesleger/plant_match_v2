import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/presentation/catolog/domain/repository/catalog_repository.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/cubit/catalog_state.dart';

class CatalogCubit extends Cubit<CatalogState> {
  final CatalogRepository catalogRepository;

  CatalogCubit({required this.catalogRepository}) : super(CatalogInitial());

  // 🔁 Charger tous les catalogues pour un utilisateur
  Future<void> loadUserCatalogs(String userId) async {
    emit(CatalogLoading());
    try {
      final catalogs = await catalogRepository.getCatalogsByUserId(userId);
      emit(CatalogLoaded(catalogs));
    } catch (e) {
      emit(CatalogError('Erreur lors du chargement des catalogues : $e'));
    }
  }

  // ➕ Créer un nouveau catalogue
  Future<void> createCatalog(Catalog catalog) async {
    emit(CatalogLoading());
    try {
      // Appeler la méthode createCatalog du repository sans attendre un "newId"
      await catalogRepository.createCatalog(catalog);

      // Après la création, charge tous les catalogues de l'utilisateur
      await loadUserCatalogs(catalog.userId);
    } catch (e) {
      emit(CatalogError('Erreur lors de la création du catalogue : $e'));
    }
  }

  // ✏️ Mettre à jour un catalogue existant
  Future<void> updateCatalog(Catalog catalog) async {
    emit(CatalogLoading());
    try {
      await catalogRepository.updateCatalog(catalog);
      await loadUserCatalogs(catalog.userId);
    } catch (e) {
      emit(CatalogError('Erreur lors de la mise à jour du catalogue : $e'));
    }
  }

  // ❌ Supprimer un catalogue
  Future<void> deleteCatalog(Catalog catalog) async {
    emit(CatalogLoading());
    try {
      await catalogRepository.deleteCatalog(catalog.uid);
      await loadUserCatalogs(catalog.userId);
    } catch (e) {
      emit(CatalogError('Erreur lors de la suppression du catalogue : $e'));
    }
  }
}
