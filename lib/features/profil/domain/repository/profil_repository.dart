import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

abstract class ProfilRepository {
  /// Récupère le profil d'un utilisateur. None si non trouvé.
  TaskEither<Failure, Option<ProfilUser>> getProfilUser(String uid);

  /// Met à jour l'ensemble du profil utilisateur
  TaskEither<Failure, Unit> updateProfilUser(ProfilUser updateProfilUser);

  /// Crée le profil utilisateur
  TaskEither<Failure, Unit> createProfilUser(ProfilUser profilUser);

  /// Met à jour un champ précis du profil
  TaskEither<Failure, Unit> updateProfilField({
    required String uid,
    required String field,
    required dynamic value,
  });

  /// Récupère un profil utilisateur par son code de parrainage
  TaskEither<Failure, Option<ProfilUser>> getProfilUserByReferralCode(
      String referralCode);

  TaskEither<Failure, Unit> incrementLeaves(String uid, int count);

  TaskEither<Failure, Unit> applyReferral({
    required String newUserUid,
    required String referrerUid,
    required String referralCode,
    required int bonus,
  });
}
