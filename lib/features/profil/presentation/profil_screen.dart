import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/avatar/avatar.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded_with_icon.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/get_started/presentation/get_started_page_route.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_state.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_card.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/features/profil/presentation/widgets/offer_premium_card.dart';
import 'package:plant_match_v2/features/profil/presentation/widgets/profil_personalization_categories.dart';
import 'package:plant_match_v2/features/profil/presentation/widgets/profil_plant_match_categories.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilCubit, ProfilState>(
      builder: (context, state) {
        final profilUser = state is ProfilLoaded ? state.profilUser : null;

        return Scaffold(
          backgroundColor: AppColors.greyUltraLight,
          appBar: profilUser != null
              ? AppBarTemplate(
                  titleWidget: TitlePage(
                    fontSize: AppTypo.textXl,
                    title: profilUser.userName.match(
                      () => profilUser.fullName.toCapitalizeWords(),
                      (userName) => userName.toCapitalizeWords(),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  backgroundColor: AppColors.white,
                  surfaceTintColor: AppColors.white,
                  shadowColor: AppColors.black,
                  leading: false,
                  leadingWith: 16,
                  preferredHeight: 70,
                  actions: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                        border: Border.all(color: AppColors.white, width: 2),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2))
                        ],
                      ),
                      child: Avatar(
                        profilUser: profilUser,
                        radius: 22,
                        imgSizeAvatar: 44,
                      ),
                    ),
                  ],
                )
              : null,
          body: switch (state) {
            ProfilInitial() || ProfilLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            ProfilError(:final message) => ErrorPage(
                errorMessage: message,
                onRetry: () =>
                    context.read<ProfilCubit>().getProfilUser(userId),
              ),
            ProfilLoaded(:final profilUser) => SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
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
                              child: const OfferPremiumCard()),
                          Padding(
                            padding: AppSpacing.paddingHorizontal +
                                const EdgeInsets.only(top: 30, bottom: 12),
                            child: Text(
                              t.profil.navigation.navigation_title.essential,
                              style: InterTextStyle.inter(
                                AppTypo.textM,
                                fontWeight: FontWeight.w700,
                                color: AppColors.greyDark,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 216,
                            child: ProfilCard(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: AppSpacing.paddingHorizontal +
                          const EdgeInsets.only(top: 30, bottom: 12),
                      child: Text(
                        t.profil.navigation.navigation_title.personalization,
                        style: InterTextStyle.inter(
                          AppTypo.textM,
                          fontWeight: FontWeight.w700,
                          color: AppColors.greyDark,
                        ),
                      ),
                    ),
                    ProfilPersonalizationCategories(
                      profilUser: profilUser,
                    ),
                    Padding(
                      padding: AppSpacing.paddingHorizontal +
                          const EdgeInsets.only(top: 30, bottom: 12),
                      child: Text(
                        t.profil.navigation.navigation_title.plant_match,
                        style: InterTextStyle.inter(
                          AppTypo.textM,
                          fontWeight: FontWeight.w700,
                          color: AppColors.greyDark,
                        ),
                      ),
                    ),
                    const ProfilPlantMatchCategories(),
                    const SizedBox(height: 30),
                    Padding(
                      padding: AppSpacing.paddingHorizontal,
                      child: SizedBox(
                        width: double.infinity,
                        child: ButtonRoundedWithIcon(
                          text: t.profil.navigation.logout,
                          onPressed: () {
                            context.read<AuthCubit>().logOut();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const GetStartedPageRoute(),
                              ),
                            );
                          },
                          bgColor: AppColors.greenLight.withValues(alpha: 0.3),
                          textColor: AppColors.blueGreen,
                          icon: const Icon(LucideIcons.log_out,
                              color: AppColors.blueGreen),
                          iconAlignment: IconAlignment.start,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ProfilImageUploading() => const SizedBox.shrink(),
          },
        );
      },
    );
  }
}
