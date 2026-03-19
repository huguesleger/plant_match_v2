import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/widgets/map_users/map_users.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class AroundMeMapView extends StatelessWidget {
  const AroundMeMapView({
    super.key,
    required this.users,
    required this.currentUser,
    required this.userCatalogs,
  });

  final List<ProfilUser> users;
  final ProfilUser currentUser;
  final Map<String, List<Catalog>> userCatalogs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: AppSpacing.paddingHorizontal,
          child: TitlePage(
            title: 'A proximité',
            fontSize: AppTypo.textXl,
          ),
        ),
        Padding(
          padding: AppSpacing.paddingHorizontal +
              const EdgeInsets.symmetric(vertical: 10),
          child: const Text(
              'Trouvez des utilisateurs autour de vous pour partager, échanger ...'),
        ),
        Expanded(
          child: MapUsers(
            users: users,
            currentUser: currentUser,
            userCatalogs: userCatalogs,
          ),
        ),
      ],
    );
  }
}
