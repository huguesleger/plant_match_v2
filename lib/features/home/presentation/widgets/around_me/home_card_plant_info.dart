import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class HomeCardPlantInfo extends StatelessWidget {
  const HomeCardPlantInfo({
    super.key,
    required this.owner,
    required this.distance,
  });

  final ProfilUser owner;
  final Option<double> distance;

  @override
  Widget build(BuildContext context) {
    final distanceText = distance.match(
      () => '2',
      (km) => km.toStringAsFixed(2),
    );
    final displayName = owner.userName.getOrElse(() => owner.firstName);
    return Row(
      children: [
        const Icon(LucideIcons.map_pin, color: AppColors.green, size: 12),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            t.home.card.distance_owner(
              distance: distanceText,
              name: displayName,
            ),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: AppTypo.textXxs,
              color: AppColors.greyMedium,
            ),
          ),
        ),
      ],
    );
  }
}
