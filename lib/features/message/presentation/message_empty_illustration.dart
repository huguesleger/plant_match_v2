import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';

class MessageEmptyIllustration extends StatelessWidget {
  const MessageEmptyIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Assets.res.images.emptyTchat.image(
          width: double.infinity,
          fit: BoxFit.fitWidth,
        ),
        Positioned.fill(
          child: Assets.res.animations.paperPlanes.lottie(fit: BoxFit.fill),
        ),
      ],
    );
  }
}
