import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/widgets/skeleton/skeleton_effect.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AppSkeletonizer extends StatelessWidget {
  const AppSkeletonizer({
    super.key,
    required this.child,
    required this.enabled,
    this.ignorePointers = true,
  });

  final Widget child;
  final bool enabled;
  final bool ignorePointers;

  @override
  Widget build(BuildContext context) => Skeletonizer(
        enabled: enabled,
        effect: SkeletonEffect.shimmer,
        ignorePointers: ignorePointers,
        textBoneBorderRadius:
            TextBoneBorderRadius(BorderRadius.circular(4)),
        child: child,
      );
}
