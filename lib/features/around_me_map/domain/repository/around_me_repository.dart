import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

abstract class AroundMeRepository {
  TaskEither<Failure, List<ProfilUser>> getUsersByIds(Set<String> uids);

  TaskEither<Failure, Unit> updateUserLocation(ProfilUser user);
}
