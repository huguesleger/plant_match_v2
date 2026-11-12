import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/dots_loader/dots_loader.dart';

class DotsLoaderPage extends StatelessWidget {
  const DotsLoaderPage({super.key});

  @override
  Widget build(BuildContext context) => const ColoredBox(
        color: AppColors.white,
        child: Center(child: DotsLoader()),
      );
}
