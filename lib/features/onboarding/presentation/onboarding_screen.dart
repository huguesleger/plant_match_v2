import 'package:flutter/material.dart';
import 'package:plant_match_v2/features/onboarding/widget/carousel/carousel.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Carousel(),
      ),
    );
  }
}
