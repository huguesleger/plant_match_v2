import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/core/widgets/refresh/refresh_fill_view.dart';
import 'package:plant_match_v2/core/widgets/refresh/refresh_screen.dart';
import 'package:plant_match_v2/core/widgets/skeleton/app_skeletonizer.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_state.dart';
import 'package:plant_match_v2/features/recent_activity/domain/entities/recent_activity.dart';
import 'package:plant_match_v2/features/recent_activity/presentation/widgets/empty_recent_activity_view.dart';
import 'package:plant_match_v2/features/recent_activity/presentation/widgets/recent_activity_list.dart';

class RecentActivityContent extends StatelessWidget {
  const RecentActivityContent({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AroundMeCubit, AroundMeState>(
        builder: (context, state) => switch (state) {
          AroundMeInitial() || AroundMeLoading() => AppSkeletonizer(
              enabled: true,
              child: RecentActivityList(
                activities: RecentActivity.boneMocks(),
              ),
            ),
          AroundMeError(:final failure) => ErrorPage(
              failure: failure,
              onRetry: () =>
                  context.read<AroundMeCubit>().getAllUserProfiles(uid),
            ),
          AroundMeLoaded(
            :final currentUser,
            :final users,
            :final userCatalogs
          ) =>
            _loaded(
              context,
              RecentActivity.fromAroundMe(
                currentUser: currentUser,
                users: users,
                userCatalogs: userCatalogs,
              ),
            ),
        },
      );

  Widget _loaded(BuildContext context, List<RecentActivity> activities) =>
      RefreshScreen(
        onRefresh: () => context.read<AroundMeCubit>().refresh(uid),
        child: activities.isEmpty
            ? const RefreshFillView(child: EmptyRecentActivityView())
            : RecentActivityList(activities: activities),
      );
}
