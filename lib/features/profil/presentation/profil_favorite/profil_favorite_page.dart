import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/profil/data/firebase_favorites_repo.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_favorite/cubit/profil_favorite_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_favorite/cubit/profil_favorite_state.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_favorite/profil_favorite_screen.dart';

class ProfilFavoritePage extends StatelessWidget {
  ProfilFavoritePage({super.key});

  final favoritesRepository = FirebaseFavoritesRepo();

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthCubit>().userId;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Utilisateur non connecté')),
      );
    }

    return Scaffold(
      appBar: AppBarTemplate(
        title: 'Mes Favoris',
        centerTitle: true,
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shadowColor: AppColors.black.withValues(alpha: 0.08),
        styleIconButton: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: const BorderSide(color: AppColors.greyLight),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      body: BlocProvider(
        create: (context) =>
            ProfilFavoriteCubit(favoritesRepository: favoritesRepository)
              ..loadFavorites(userId),
        child: BlocBuilder<ProfilFavoriteCubit, ProfilFavoriteState>(
          builder: (context, state) {
            return switch (state) {
              ProfilFavoriteInitial() ||
              ProfilFavoriteLoading() =>
                const Center(child: CircularProgressIndicator()),
              ProfilFavoriteError() => ErrorPage(errorMessage: state.message),
              ProfilFavoriteLoaded() => ProfilFavoriteScreen(
                  uid: userId,
                  plants: state.plants,
                  users: state.users,
                ),
            };
          },
        ),
      ),
    );
  }
}
