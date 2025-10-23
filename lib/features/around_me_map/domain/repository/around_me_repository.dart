import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

abstract class AroundMeRepository {
  Future<List<ProfilUser>> getAllUserUids();

  Future<void> updateUserLocation(ProfilUser user);
}
