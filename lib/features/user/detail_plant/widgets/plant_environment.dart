import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

class PlantEnvironment extends StatelessWidget {
  const PlantEnvironment({super.key, required this.environment});

  final Environment environment;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          t.user.detail_plant.env_prefix(env: environment.envName),
          style: InterTextStyle.inter(
            AppTypo.textS,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(width: 5),
        ClipOval(
          child: Container(
            color: AppColors.greenLight.withValues(alpha: 0.5),
            width: 25,
            height: 25,
            child: Icon(
              environment == Environment.outdoor
                  ? LucideIcons.trees
                  : LucideIcons.house,
              color: AppColors.blueGreen,
              size: AppTypo.textS,
            ),
          ),
        ),
      ],
    );
  }
}
