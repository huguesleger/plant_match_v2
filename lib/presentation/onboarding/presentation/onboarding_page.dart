import 'package:flutter/material.dart';
import 'package:plant_match_v2/presentation/onboarding/widget/carousel/carousel.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height > 700 ? 90 : 50),
        child: const Carousel(),
      ),
    ));
  }
}
