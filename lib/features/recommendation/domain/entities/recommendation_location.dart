import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/util/distance/distance_helper.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class RecommendationLocation {
  final ProfilUser currentUser;
  final List<ProfilUser> users;

  const RecommendationLocation({
    required this.currentUser,
    required this.users,
  });

  Option<double> distanceTo(String ownerId) => users
      .where((user) => user.uid == ownerId)
      .firstOption
      .flatMap((owner) => DistanceHelper.distanceBetween(currentUser, owner));
}
