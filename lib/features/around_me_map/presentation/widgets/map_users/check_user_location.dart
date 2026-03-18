import 'package:flutter/material.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/widgets/map_users/around_me_map_view.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/widgets/map_users/around_me_no_location_view.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class CheckUserLocation extends StatelessWidget {
  const CheckUserLocation({
    super.key,
    required this.currentUser,
    required this.users,
    required this.userCatalogs,
  });

  final ProfilUser currentUser;
  final List<ProfilUser> users;
  final Map<String, List<Catalog>> userCatalogs;

  @override
  Widget build(BuildContext context) {
    final bool hasValidLocation = currentUser.latitude != null &&
        currentUser.longitude != null &&
        currentUser.latitude != 0 &&
        currentUser.longitude != 0;

    return hasValidLocation
        ? AroundMeMapView(
            users: users,
            currentUser: currentUser,
            userCatalogs: userCatalogs,
          )
        : AroundMeNoLocationView(profilUser: currentUser);
  }
}
