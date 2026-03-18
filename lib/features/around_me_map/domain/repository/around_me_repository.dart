import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

abstract class AroundMeRepository {
  /// Récupère tous les profils utilisateurs
  TaskEither<Failure, List<ProfilUser>> getAllUserUids();

  /// Met à jour la localisation de l'utilisateur
  TaskEither<Failure, Unit> updateUserLocation(ProfilUser user);
}
