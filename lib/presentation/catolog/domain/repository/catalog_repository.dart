import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';

abstract class CatalogRepository {
  Future<void> createCatalog(Catalog catalog);

  Future<Catalog?> getCatalog(String uid);

  Future<void> updateCatalog(Catalog catalog);

  Future<void> updateImageCatalog(String uid, List<String> imageUrls);
}
