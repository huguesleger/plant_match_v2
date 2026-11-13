import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/features/recent_activity/presentation/widgets/recent_activity_content.dart';

class RecentActivityScreen extends StatelessWidget {
  const RecentActivityScreen({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.greyUltraLight,
        appBar: AppBarTemplate(
          title: Some(t.recentActivity.screen.title),
          backgroundColor: AppColors.greyUltraLight,
          surfaceTintColor: AppColors.greyUltraLight,
          styleIconButton: Some(
            IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: const BorderSide(color: AppColors.greyLight),
            ),
          ),
          onPressed: Some(() => Navigator.pop(context)),
        ),
        body: SafeArea(child: RecentActivityContent(uid: uid)),
      );
}
