import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

abstract class CatalogRepository {
  TaskEither<Failure, Unit> updateCatalog(Catalog catalog);

  TaskEither<Failure, List<Catalog>> getCatalogsByUserId(String userId);

  TaskEither<Failure, Option<Catalog>> getCatalogById(String catalogId);

  TaskEither<Failure, String> createCatalog(Catalog catalog);

  String reserveCatalogId();

  TaskEither<Failure, List<Catalog>> getPublishedCatalogs({required int limit});

  TaskEither<Failure, Unit> deleteCatalog(String catalogId);

  Stream<Option<Catalog>> watchCatalog(String catalogId);

  Stream<List<Catalog>> watchCatalogsByUserId(String userId);

  TaskEither<Failure, Unit> incrementCatalogViews(String catalogId);
}
