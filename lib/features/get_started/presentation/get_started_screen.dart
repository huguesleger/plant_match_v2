import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/features/get_started/presentation/widgets/get_started_bg_image.dart';
import 'package:plant_match_v2/features/get_started/presentation/widgets/get_started_content.dart';
import 'package:plant_match_v2/features/get_started/presentation/widgets/get_started_logo.dart';
import 'package:plant_match_v2/features/onboarding/presentation/onboarding_page_route.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueGreen,
      extendBody: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const GetStartedBgImage(),
          Column(
            children: [
              const GetStartedLogo(),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: AppSpacing.paddingHorizontal +
                        EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom + 120,
                        ),
                    child: const GetStartedContent(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingHorizontal + AppSpacing.paddingVertical,
          child: ButtonRounded(
            text: t.getStarted.button,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OnboardingPageRoute(),
              ),
            ),
            bgColor: AppColors.greenLight,
            textColor: AppColors.blueGreen,
          ),
        ),
      ),
    );
  }
}
