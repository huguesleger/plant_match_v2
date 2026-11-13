import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/features/recent_activity/domain/entities/recent_activity.dart';
import 'package:plant_match_v2/features/recent_activity/presentation/widgets/recent_activity_tile.dart';

class RecentActivityList extends StatelessWidget {
  const RecentActivityList({
    super.key,
    required this.activities,
  });

  final List<RecentActivity> activities;

  @override
  Widget build(BuildContext context) => ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppSpacing.paddingAll,
        itemCount: activities.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, index) => RecentActivityTile(
          activity: activities[index],
        ),
      );
}
