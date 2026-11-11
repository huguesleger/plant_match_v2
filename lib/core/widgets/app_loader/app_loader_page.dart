import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_loader/app_loader.dart';

class AppLoaderPage extends StatelessWidget {
  const AppLoaderPage({super.key});

  @override
  Widget build(BuildContext context) => const ColoredBox(
        color: AppColors.white,
        child: Center(child: AppLoader()),
      );
}
