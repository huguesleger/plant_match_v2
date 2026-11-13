import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/core/widgets/refresh/refresh_screen.dart';
import 'package:plant_match_v2/core/widgets/skeleton/app_skeletonizer.dart';
import 'package:plant_match_v2/features/user/presentation/cubit/user_cubit.dart';
import 'package:plant_match_v2/features/user/presentation/cubit/user_state.dart';
import 'package:plant_match_v2/features/user/presentation/header/user_header_with_content.dart';
import 'package:plant_match_v2/features/user/presentation/widgets/user_profile_body.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) => switch (state) {
          UserInitial() => const SizedBox.shrink(),
          UserLoading(:final boneMock) => UserHeaderWithContent(
              user: boneMock.user,
              isLoading: true,
              child: AppSkeletonizer(
                enabled: true,
                child: UserProfileBody(data: boneMock),
              ),
            ),
          UserError(:final failure) => ErrorPage(
              failure: failure,
              onRetry: () => context.read<UserCubit>().fetchUser(uid),
            ),
          UserLoaded(:final data) => RefreshScreen(
              onRefresh: () => context.read<UserCubit>().refresh(uid),
              notificationPredicate: (notification) => notification.depth == 1,
              child: UserHeaderWithContent(
                user: data.user,
                child: UserProfileBody(data: data),
              ),
            ),
        },
      ),
    );
  }
}
