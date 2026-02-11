import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/user_points/domain/entities/user_points.dart';
import 'package:plant_match_v2/core/failures/failure.dart';

/// Interface du repository pour la gestion des points utilisateur
/// Utilise TaskEither pour une gestion d'erreurs fonctionnelle
abstract class UserPointsRepository {
  /// Ajoute des points initiaux pour un utilisateur
  /// Retourne [Right(UserPoints)] en cas de succès
  /// Retourne [Left(Failure)] en cas d'erreur
  TaskEither<Failure, UserPoints> addPoints(
    String userId,
    int initialPoints,
    int level,
  );

  /// Met à jour les points d'un utilisateur
  /// Retourne [Right(Unit)] en cas de succès
  /// Retourne [Left(Failure)] en cas d'erreur
  TaskEither<Failure, Unit> updatePoints(
    String userId,
    int pointsToAdd,
  );

  /// Récupère les points d'un utilisateur
  /// Retourne [Right(UserPoints)] en cas de succès
  /// Retourne [Left(Failure)] en cas d'erreur (ex: utilisateur non trouvé)
  TaskEither<Failure, UserPoints> getPoints(String userId);
}
