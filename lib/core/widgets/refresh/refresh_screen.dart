import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class RefreshScreen extends StatelessWidget {
  const RefreshScreen({
    super.key,
    required this.onRefresh,
    required this.child,
    this.notificationPredicate = defaultScrollNotificationPredicate,
  });

  final Future<void> Function() onRefresh;
  final Widget child;
  final ScrollNotificationPredicate notificationPredicate;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.greenDark,
      backgroundColor: AppColors.white,
      onRefresh: onRefresh,
      notificationPredicate: notificationPredicate,
      child: child,
    );
  }
}
