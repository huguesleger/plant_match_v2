import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/home_section_message.dart';
import 'package:plant_match_v2/features/recent_activity/domain/entities/recent_activity.dart';
import 'package:plant_match_v2/features/recent_activity/presentation/widgets/recent_activity_tile.dart';

class HomeRecentActivity extends StatelessWidget {
  const HomeRecentActivity({
    super.key,
    required this.activities,
    required this.onSeeAllPressed,
  });

  final List<RecentActivity> activities;
  final VoidCallback onSeeAllPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.home.recent_activity.title,
                style: const TextStyle(
                  fontSize: AppTypo.textM,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              TextButton.icon(
                onPressed: onSeeAllPressed,
                iconAlignment: IconAlignment.end,
                label: Text(
                  t.home.recent_activity.see_all,
                  style: const TextStyle(
                    color: AppColors.greyMedium,
                    fontSize: AppTypo.textXs,
                  ),
                ),
                icon: const Icon(
                  LucideIcons.chevron_right,
                  color: AppColors.greyMedium,
                  size: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        activities.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: HomeSectionMessage(
                  message: t.home.recent_activity.empty,
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activities.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) => RecentActivityTile(
                  activity: activities[index],
                ),
              ),
      ],
    );
  }
}
