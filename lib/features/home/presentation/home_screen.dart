import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_state.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/home_loaded_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthCubit>().userId ?? '';

    return Scaffold(
      backgroundColor: AppColors.greyUltraLight,
      body: SafeArea(
        child: BlocBuilder<AroundMeCubit, AroundMeState>(
          builder: (context, state) => switch (state) {
            AroundMeInitial() ||
            AroundMeLoading() =>
              const Center(child: CircularProgressIndicator()),
            AroundMeError(:final message) => ErrorPage(
                errorMessage: message,
                onRetry: () =>
                    context.read<AroundMeCubit>().getAllUserProfiles(uid),
              ),
            AroundMeLoaded(
              :final users,
              :final currentUser,
              :final userCatalogs
            ) =>
              HomeLoadedContent(
                currentUser: currentUser,
                users: users,
                userCatalogs: userCatalogs,
              ),
          },
        ),
      ),
    );
  }
}
