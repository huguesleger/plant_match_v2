import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_badge/profil_badge_screen.dart';
import 'package:plant_match_v2/features/user_points/data/firebase_user_points.dart';
import 'package:plant_match_v2/features/user_points/presentation/cubit/user_points_cubit.dart';
import 'package:plant_match_v2/features/user_points/presentation/cubit/user_points_state.dart';

class ProfilBadgePage extends StatelessWidget {
  ProfilBadgePage({super.key});

  final userPointsRepository = FirebaseUserPoints();

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthCubit>().userId;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text("Utilisateur non connecté")),
      );
    }
    return Scaffold(
      appBar: AppBarTemplate(
        title: 'Mes badges',
        centerTitle: true,
        backgroundColor: AppColors.greenLight,
        surfaceTintColor: AppColors.white,
        styleIconButton: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: const BorderSide(color: AppColors.greyDark),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: BlocProvider(
        create: (context) => UserPointsCubit(repository: userPointsRepository)
          ..fetchUserPoints(userId),
        child: BlocBuilder<UserPointsCubit, UserPointsState>(
          builder: (context, state) {
            return switch (state) {
              UserPointsInitial() ||
              UserPointsLoading() =>
                const Center(child: CircularProgressIndicator()),
              UserPointsError() => ErrorPage(errorMessage: state.message),
              UserPointsLoaded() =>
                ProfilBadgeScreen(userPoints: state.userPoints),
            };
          },
        ),
      ),
    );
  }
}
