import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';

class GetStartedLogo extends StatelessWidget {
  const GetStartedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: Assets.res.logo.logoWhite.svg(),
      ),
    );
  }
}
