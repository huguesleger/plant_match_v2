import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/core/widgets/skeleton/app_skeletonizer.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_card.dart';
import 'package:plant_match_v2/features/profil/presentation/widgets/offer_premium_card.dart';
import 'package:plant_match_v2/features/profil/presentation/widgets/profil_logout_button.dart';
import 'package:plant_match_v2/features/profil/presentation/widgets/profil_personalization_categories.dart';
import 'package:plant_match_v2/features/profil/presentation/widgets/profil_plant_match_categories.dart';

class ProfilContent extends StatelessWidget {
  const ProfilContent({
    super.key,
    required this.profilUser,
    required this.userId,
    required this.isLoading,
  });

  final ProfilUser profilUser;
  final String userId;
  final bool isLoading;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: AppSpacing.paddingHorizontal +
                        const EdgeInsets.only(top: 30),
                    child: const OfferPremiumCard(),
                  ),
                  _SectionTitle(
                    title: t.profil.navigation.navigation_title.essential,
                  ),
                  const SizedBox(height: 216, child: ProfilCard()),
                ],
              ),
            ),
            _SectionTitle(
              title: t.profil.navigation.navigation_title.personalization,
            ),
            AppSkeletonizer(
              enabled: isLoading,
              child: ProfilPersonalizationCategories(profilUser: profilUser),
            ),
            _SectionTitle(
              title: t.profil.navigation.navigation_title.plant_match,
            ),
            const ProfilPlantMatchCategories(),
            const SizedBox(height: 30),
            ProfilLogoutButton(userId: userId),
            const SizedBox(height: 30),
          ],
        ),
      );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: AppSpacing.paddingHorizontal +
            const EdgeInsets.only(top: 30, bottom: 12),
        child: Text(
          title,
          style: InterTextStyle.inter(
            AppTypo.textM,
            fontWeight: FontWeight.w700,
            color: AppColors.greyDark,
          ),
        ),
      );
}
