import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/onboarding/presentation/onboarding_page_route.dart';

class GetStartedContent extends StatelessWidget {
  const GetStartedContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TitlePage(
          title: 'Échangez, adoptez et cultivez ensemble.',
          fontSize: AppTypo.textXxl,
          fontWeight: FontWeight.bold,
          color: AppColors.greenLight,
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            'Rejoignez la communauté des amoureux des plantes près de chez vous.',
            style: TextStyle(
              fontSize: AppTypo.textS,
              color: AppColors.white,
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ButtonRounded(
                  text: 'C\'est parti !',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnboardingPageRoute(),
                      ),
                    );
                  },
                  bgColor: AppColors.greenLight,
                  textColor: AppColors.blueGreen,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
