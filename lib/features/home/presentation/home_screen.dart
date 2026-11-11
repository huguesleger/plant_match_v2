import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_state.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/home_header.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_state.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/home_loaded_content.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/home_recommendation_refresher.dart';
import 'package:plant_match_v2/features/recommendation/data/repositories/recommendation_repository_impl.dart';
import 'package:plant_match_v2/features/recommendation/presentation/cubit/saved_recommendation_cubit.dart';
import 'package:plant_match_v2/core/widgets/app_loader/app_loader_page.dart';
import 'package:plant_match_v2/core/widgets/app_loader/app_loader_gate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthCubit>().userId.getOrElse(() => '');

    return BlocProvider(
      create: (context) => SavedRecommendationCubit(
        repository: RecommendationRepositoryImpl(),
      )..loadSavedRecommendations(uid),
      child: HomeRecommendationRefresher(
        uid: uid,
        child: BlocBuilder<AroundMeCubit, AroundMeState>(
          builder: (context, state) => AppLoaderGate(
            isLoading: state is AroundMeInitial || state is AroundMeLoading,
            child: switch (state) {
              AroundMeInitial() || AroundMeLoading() => const Scaffold(
                  backgroundColor: AppColors.white,
                  body: AppLoaderPage(),
                ),
              AroundMeError(:final failure) => Scaffold(
                  backgroundColor: AppColors.white,
                  body: SafeArea(
                    child: ErrorPage(
                      failure: failure,
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
                    shadowColor: const Some(AppColors.black),
                    leading: false,
                    leadingWith: 0,
                    preferredHeight: 100,
                    titleWidget: Some(Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: BlocBuilder<ProfilCubit, ProfilState>(
                        buildWhen: (_, current) => current is ProfilLoaded,
                        builder: (context, profilState) => HomeHeader(
                          firstName: currentUser.firstName,
                          profilImg: currentUser.profilImg,
                          userName: currentUser.userName,
                          leaves: switch (profilState) {
                            ProfilLoaded(:final profilUser) => profilUser.leaves,
                            ProfilInitial() ||
                            ProfilLoading() ||
                            ProfilError() ||
                            ProfilImageUploading() =>
                              currentUser.leaves,
                          },
                        ),
                      ),
                    )),
                  ),
                  body: HomeLoadedContent(
                    currentUser: currentUser,
                    users: users,
                    userCatalogs: userCatalogs,
                  ),
                ),
            },
          ),
        ),
      ),
    );
  }
}
