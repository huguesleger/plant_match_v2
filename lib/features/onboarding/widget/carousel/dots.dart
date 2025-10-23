import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Dots extends StatelessWidget {
  const Dots({super.key, required this.controller});

  final PageController controller;
  static const double defaultHeight = 335;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height > 900 ? defaultHeight : 270,
      alignment: Alignment.bottomCenter,
      child: SmoothPageIndicator(
        controller: controller,
        count: 4,
        effect: const ExpandingDotsEffect(
          dotColor: AppColors.greyLight,
          activeDotColor: AppColors.greenLight,
          dotWidth: 8,
          dotHeight: 8,
        ),
      ),
    );
  }
}
