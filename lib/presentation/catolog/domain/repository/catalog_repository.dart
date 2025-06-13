import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';

abstract class CatalogRepository {
  Future<List<Catalog>> getUserCatalogs(String userId);

  Future<Catalog?> getCatalogById(String uid);

  Future<String> createCatalog(Catalog catalog);

  Future<void> updateCatalog(Catalog catalog);

  Future<void> deleteCatalog(String uid);
}
