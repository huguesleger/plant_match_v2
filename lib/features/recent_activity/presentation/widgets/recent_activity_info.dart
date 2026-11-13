import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/features/recent_activity/domain/entities/recent_activity.dart';

class RecentActivityInfo extends StatelessWidget {
  const RecentActivityInfo({super.key, required this.activity});

  final RecentActivity activity;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: AppColors.black,
                fontSize: AppTypo.textS,
              ),
              children: [
                TextSpan(
                  text: activity.owner.userName
                      .getOrElse(() => activity.owner.firstName),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: t.recentActivity.tile.added_plant),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                LucideIcons.calendar_clock,
                color: AppColors.greyMedium,
                size: 12,
              ),
              const SizedBox(width: 6),
              Text(
                _timeAgo(DateTime.now().difference(activity.catalog.createdAt)),
                style: const TextStyle(
                  color: AppColors.greyMedium,
                  fontSize: AppTypo.textXs,
                ),
              ),
            ],
          ),
        ],
      );

  String _timeAgo(Duration elapsed) => switch (elapsed) {
        Duration(inMinutes: < 60) =>
          t.recentActivity.tile.minutes(count: elapsed.inMinutes),
        Duration(inHours: < 24) =>
          t.recentActivity.tile.hours(count: elapsed.inHours),
        Duration() => t.recentActivity.tile.days(count: elapsed.inDays),
      };
}
