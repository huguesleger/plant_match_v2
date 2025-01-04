import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/presentation/onboarding/presentation/onboarding_page.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.blueGreen,
      body: Stack(
        children: [
          _BgImage(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Logo(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _Content(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BgImage extends StatelessWidget {
  const _BgImage();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_intro.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TitlePage(
          title: 'Échangez, adoptez et cultivez ensemble.',
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: AppColors.greenLight,
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 70),
          child: Text(
            'Rejoignez la communauté des amoureux des plantes près de chez vous.',
            style: TextStyle(
              fontSize: AppTypo.textS,
              color: AppColors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 50),
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
                        builder: (context) => const OnboardingPage(),
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

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: SvgPicture.asset('assets/logo/logo_white.svg'),
      ),
    );
  }
}
