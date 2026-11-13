import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonEffect {
  static const shimmerMinimumDelay = Duration(milliseconds: 500);

  static const shimmer = ShimmerEffect(
    baseColor: AppColors.greyLight,
    highlightColor: AppColors.greyUltraLight,
    duration: Duration(milliseconds: 700),
  );
}
