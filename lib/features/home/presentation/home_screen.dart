import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_state.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/home_header.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/home_loaded_content.dart';
import 'package:plant_match_v2/features/recommendation/data/repositories/recommendation_repository_impl.dart';
import 'package:plant_match_v2/features/recommendation/presentation/cubit/saved_recommendation_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthCubit>().userId ?? '';

    return BlocProvider(
      create: (context) => SavedRecommendationCubit(
        repository: RecommendationRepositoryImpl(),
      )..loadSavedRecommendations(uid),
      child: BlocBuilder<AroundMeCubit, AroundMeState>(
        builder: (context, state) => switch (state) {
          AroundMeInitial() || AroundMeLoading() => const Scaffold(
              backgroundColor: AppColors.white,
              body: SafeArea(
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          AroundMeError(:final message) => Scaffold(
              backgroundColor: AppColors.white,
              body: SafeArea(
                child: ErrorPage(
                  errorMessage: message,
                  onRetry: () =>
                      context.read<AroundMeCubit>().getAllUserProfiles(uid),
                ),
              ),
            ),
          AroundMeLoaded(
            :final users,
            :final currentUser,
            :final userCatalogs,
          ) =>
            Scaffold(
              backgroundColor: AppColors.white,
              appBar: AppBarTemplate(
                backgroundColor: AppColors.white,
                surfaceTintColor: AppColors.white,
                shadowColor: AppColors.black,
                leading: false,
                leadingWith: 0,
                preferredHeight: 100,
                titleWidget: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: HomeHeader(
                    firstName: currentUser.firstName,
                    fullName: currentUser.fullName,
                    profilImg: currentUser.profilImg,
                  ),
                ),
              ),
              body: HomeLoadedContent(
                currentUser: currentUser,
                users: users,
                userCatalogs: userCatalogs,
              ),
            ),
        },
      ),
    );
  }
}
