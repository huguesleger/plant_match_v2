import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/features/level_awarded/presentation/widgets/level_awarded_success_view.dart';

class LevelAwardedScreen extends StatelessWidget {
  const LevelAwardedScreen({
    super.key,
    required this.leavesGained,
    required this.title,
    required this.description,
  });

  final int leavesGained;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greenLight,
      appBar: AppBarTemplate(
        backgroundColor: Colors.transparent,
        surfaceTintColor: AppColors.white,
        leading: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(LucideIcons.x, color: AppColors.greyDark),
          ),
        ],
      ),
      body: LevelAwardedSuccessView(
        leavesGained: leavesGained,
        title: title,
        description: description,
      ),
    );
  }
}
