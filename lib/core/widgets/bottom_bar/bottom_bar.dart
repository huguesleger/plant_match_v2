import 'package:flutter/cupertino.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 15.0,
          )
        ],
      ),
      child: Padding(padding: const EdgeInsets.only(bottom: 20), child: child),
    );
  }
}
