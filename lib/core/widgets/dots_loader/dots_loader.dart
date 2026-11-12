import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';

class DotsLoader extends StatelessWidget {
  const DotsLoader({super.key, this.width = 72});

  final double width;

  static const minDuration = Duration(seconds: 1);

  @override
  Widget build(BuildContext context) =>
      Assets.res.animations.plantMatchDotsLoader.lottie(
        width: width,
        fit: BoxFit.contain,
      );
}
