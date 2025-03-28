import 'package:flutter/cupertino.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20) +
          const EdgeInsets.only(top: 16, bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: 15.0,
          )
        ],
      ),
      child: SafeArea(
        child: child,
      ),
    );
  }
}
