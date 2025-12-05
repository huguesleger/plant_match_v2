import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

abstract class UserRepository {
  Future<ProfilUser> getUserUid(String uid);
}
