import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';

abstract class CatalogRepository {
  Future<String> createEmptyCatalog(String userId);

  Future<void> updateCatalog(Catalog catalog);

  Future<List<Catalog>> getCatalogsByUserId(String userId);

  Future<Catalog?> getCatalogById(String catalogId);

  Future<void> deleteCatalog(String catalogId);
}
