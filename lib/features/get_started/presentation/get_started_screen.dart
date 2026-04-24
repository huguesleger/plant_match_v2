import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/features/get_started/presentation/widgets/get_started_bg_image.dart';
import 'package:plant_match_v2/features/get_started/presentation/widgets/get_started_content.dart';
import 'package:plant_match_v2/features/get_started/presentation/widgets/get_started_logo.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.blueGreen,
      body: Stack(
        children: [
          GetStartedBgImage(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetStartedLogo(),
              Padding(
                padding: AppSpacing.paddingHorizontal,
                child: GetStartedContent(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
