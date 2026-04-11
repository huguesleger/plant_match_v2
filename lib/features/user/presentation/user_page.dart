import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/catalog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/features/exchange/data/firebase_exchange.dart';
import 'package:plant_match_v2/features/user/data/firebase_user.dart';
import 'package:plant_match_v2/features/user/presentation/cubit/user_cubit.dart';
import 'package:plant_match_v2/features/user/presentation/cubit/user_state.dart';
import 'package:plant_match_v2/features/user/presentation/user_screen.dart'
    show UserScreen;
import 'package:plant_match_v2/features/level/data/firebase_user_points.dart';

class UserPage extends StatelessWidget {
  UserPage({super.key, required this.uid});

  final userRepository = FirebaseUser();
  final catalogRepository = FirebaseCatalogRepository();
  final userPointsRepository = FirebaseUserPoints();
  final exchangeRepository = FirebaseExchange();
  final String uid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit(
        userRepository: userRepository,
        catalogRepository: catalogRepository,
        userPointsRepository: userPointsRepository,
        exchangeRepository: exchangeRepository,
      )..fetchUser(uid),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          return switch (state) {
            UserInitial() || UserLoading() => const Scaffold(
                backgroundColor: AppColors.white,
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            UserError() => ErrorPage(
                errorMessage: state.message,
                onRetry: () {
                  context.read<UserCubit>().fetchUser(uid);
                },
              ),
            UserLoaded(:final data) => UserScreen(
                data: data,
              ),
          };
        },
      ),
    );
  }
}
