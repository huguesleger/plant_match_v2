import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

abstract class CatalogRepository {
  /// Met à jour un catalogue
  TaskEither<Failure, Unit> updateCatalog(Catalog catalog);

  /// Récupère tous les catalogues d'un utilisateur
  TaskEither<Failure, List<Catalog>> getCatalogsByUserId(String userId);

  /// Récupère un catalogue par son ID. None si non trouvé.
  TaskEither<Failure, Option<Catalog>> getCatalogById(String catalogId);

  /// Crée un catalogue et retourne son ID
  TaskEither<Failure, String> createCatalog(Catalog catalog);

  /// Supprime un catalogue
  TaskEither<Failure, Unit> deleteCatalog(String catalogId);

  /// Observe un catalogue en temps réel
  Stream<Catalog?> watchCatalog(String catalogId);

  /// Observe tous les catalogues d'un utilisateur en temps réel
  Stream<List<Catalog>> watchCatalogsByUserId(String userId);
}
