import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_header_image.dart';
import 'package:plant_match_v2/features/level/level_detail/utils/user_level_details.dart';
import 'package:plant_match_v2/features/level/level_detail/widgets/level_detail_content.dart';
import 'package:plant_match_v2/features/level/level_detail/widgets/level_detail_icon.dart';
import 'package:plant_match_v2/features/level/level_detail/widgets/level_detail_title.dart';

class LevelDetailScreen extends StatelessWidget {
  const LevelDetailScreen({super.key, required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    final levelData = UserLevelDetails.getLevelDetails(level);
    return Scaffold(
      appBar: AppBarHeaderImage(
        image: const Image(
          image: AssetImage('assets/images/bg_profil_level_detail.jpg'),
          fit: BoxFit.cover,
        ),
        onPressed: () => Navigator.pop(context),
        styleIconButton: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: AppColors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            LevelDetailIcon(level: level),
            const SizedBox(height: 10),
            LevelDetailTitle(level: level),
            const SizedBox(height: 40),
            LevelDetailContent(levelData: levelData),
          ],
        ),
      ),
    );
  }
}
