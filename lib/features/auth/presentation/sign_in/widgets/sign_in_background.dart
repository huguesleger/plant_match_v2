import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import '../sign_in_screen.dart';

class SignInBackground extends StatelessWidget {
  const SignInBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final settings =
        context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();

    final t = settings == null
        ? 1.0
        : ((settings.currentExtent - settings.minExtent) /
                (settings.maxExtent - settings.minExtent))
            .clamp(0.0, 1.0);

    final tCurve = (t * 2.0 - 1.2).clamp(0.0, 1.0);

    final curveHeight = 60.0 * tCurve;

    return ClipPath(
      clipper: BottomRoundedClipper(
        curveHeight: curveHeight,
        progress: tCurve,
      ),
      child: Assets.res.images.auth.login.image(
        fit: BoxFit.cover,
      ),
    );
  }
}
