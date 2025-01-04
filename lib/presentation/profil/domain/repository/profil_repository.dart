import 'package:plant_match_v2/presentation/profil/domain/entity/profil_user.dart';

abstract class ProfilRepository {
  Future<ProfilUser?> getProfilUser(String uid);

  Future<void> updateProfilUser(ProfilUser updateProfilUser);

  Future<void> createProfilUser(ProfilUser profilUser);
}
