import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';

class GetStartedBgImage extends StatelessWidget {
  const GetStartedBgImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.res.images.bgIntro.provider(),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
