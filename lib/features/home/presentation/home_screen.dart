import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/home/domain/entities/home.dart';
import 'package:plant_match_v2/features/home/presentation/cubit/home_cubit.dart';
import 'package:plant_match_v2/features/home/presentation/cubit/home_state.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/header/home_app_bar.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/home_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) => BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) => switch (state) {
          HomeLoading(:final boneMock) =>
            _page(boneMock, state, isLoading: true),
          HomeError(:final failure) => Scaffold(
              backgroundColor: AppColors.white,
              body: SafeArea(
                child: ErrorPage(
                  failure: failure,
                  onRetry: () =>
                      context.read<AroundMeCubit>().getAllUserProfiles(uid),
                ),
              ),
            ),
          HomeLoaded(:final home) => _page(home, state, isLoading: false),
        },
      );

  Widget _page(Home home, HomeState state, {required bool isLoading}) =>
      Scaffold(
        backgroundColor: AppColors.white,
        appBar: HomeAppBar(
          user: home.currentUser,
          leaves: state.leaves.getOrElse(() => home.currentUser.leaves),
          isLoading: isLoading,
        ),
        body: HomeContent(
          uid: uid,
          home: home,
          filter: state.filter,
          recommendation: state.recommendation,
          isLoading: isLoading,
        ),
      );
}
