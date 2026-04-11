import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_card/profil_card.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_header/profil_header.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_navigation/profil_navigation.dart';

class ProfilView extends StatelessWidget {
  const ProfilView({super.key, required this.profilUser});

  final ProfilUser profilUser;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: AppSpacing.paddingHorizontal,
            child: ProfilHeader(profilUser: profilUser),
          ),
          const SizedBox(height: 50),
          const SizedBox(
            height: 216,
            child: ProfilCard(),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.greyUltraLight,
              ),
              child: Padding(
                padding: AppSpacing.paddingHorizontal +
                    const EdgeInsets.symmetric(vertical: 30),
                child: ProfilNavigation(profilUser: profilUser),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
