import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/widgets/avatar/avatar.dart';
import 'package:plant_match_v2/features/recent_activity/domain/entities/recent_activity.dart';
import 'package:plant_match_v2/features/recent_activity/presentation/widgets/recent_activity_info.dart';
import 'package:plant_match_v2/features/recent_activity/presentation/widgets/recent_activity_thumbnail.dart';
import 'package:plant_match_v2/features/user/detail_plant/detail_plant.dart';

class RecentActivityTile extends StatelessWidget {
  const RecentActivityTile({
    super.key,
    required this.activity,
  });

  final RecentActivity activity;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailPlant(
              catalog: activity.catalog,
              owner: Some(activity.owner),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            children: [
              Avatar(
                profilUser: Some(activity.owner),
                radius: 22,
                imgSizeAvatar: 44,
              ),
              const SizedBox(width: 12),
              Expanded(child: RecentActivityInfo(activity: activity)),
              const SizedBox(width: 10),
              RecentActivityThumbnail(catalog: activity.catalog),
            ],
          ),
        ),
      );
}
