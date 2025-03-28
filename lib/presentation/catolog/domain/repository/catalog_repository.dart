import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';

abstract class CatalogRepository {
  Future<void> addCatalog(Catalog catalog);

  Future<Catalog?> getCatalog(String uid);

  Future<void> updateCatalog(Catalog catalog);

  Future<List<Catalog>> fetchCatalogs(String uid);
}
