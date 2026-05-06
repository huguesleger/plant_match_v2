import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignInHeaderLogo extends StatelessWidget {
  const SignInHeaderLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final settings =
        context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    if (settings == null) return const SizedBox.shrink();

    final t = (settings.currentExtent - settings.minExtent) /
        (settings.maxExtent - settings.minExtent)
            .clamp(0.0001, double.infinity);

    final opacityExpanded = t.clamp(0.0, 1.0);
    final opacityShrink = (1.0 - t).clamp(0.0, 1.0);

    final isBigScreen = MediaQuery.of(context).size.height > 700;
    // On reproduit les paddings d'origine mais de manière interpolée
    final bottomExpanded = isBigScreen ? 140.0 : 70.0;
    const bottomShrink = -12.0; // on descend encore un peu plus vers le bas
    final currentBottom = bottomShrink + (bottomExpanded - bottomShrink) * t;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: currentBottom,
          left: 0,
          right: 0,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: opacityExpanded,
                  child: SvgPicture.asset('res/logo/logo_white.svg'),
                ),
                Opacity(
                  opacity: opacityShrink,
                  child: SvgPicture.asset(
                    'res/logo/logo_color.svg',
                    width: 60,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
