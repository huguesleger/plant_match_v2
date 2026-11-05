import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

abstract class ProfilRepository {
  TaskEither<Failure, Option<ProfilUser>> getProfilUser(String uid);

  TaskEither<Failure, Unit> updateProfilUser(ProfilUser updateProfilUser);

  TaskEither<Failure, Unit> createProfilUser(ProfilUser profilUser);

  TaskEither<Failure, Unit> updateProfilField({
    required String uid,
    required String field,
    required dynamic value,
  });

  TaskEither<Failure, int> applyReferral(String referralCode);
}
