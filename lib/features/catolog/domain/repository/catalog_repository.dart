import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';

abstract class CatalogRepository {
  Future<void> updateCatalog(Catalog catalog);

  Future<List<Catalog>> getCatalogsByUserId(String userId);

  Future<Catalog?> getCatalogById(String catalogId);

  Future<String> createCatalog(Catalog catalog);

  Future<void> deleteCatalog(String catalogId);

  Stream<Catalog?> watchCatalog(String catalogId);

  Stream<List<Catalog>> watchCatalogsByUserId(String userId);
}
