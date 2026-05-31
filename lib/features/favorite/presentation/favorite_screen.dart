import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:plant_match_v2/features/favorite/presentation/cubit/favorite_state.dart';
import 'package:plant_match_v2/features/favorite/presentation/widgets/favorite_plants_tab.dart';
import 'package:plant_match_v2/features/favorite/presentation/widgets/favorite_users_tab.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({
    super.key,
    required this.uid,
  });

  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTemplate(
        title: t.favorite.screen.title,
        centerTitle: true,
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shadowColor: AppColors.black,
        styleIconButton: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: const BorderSide(color: AppColors.greyLight),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) => switch (state) {
          FavoriteInitial() ||
          FavoriteLoading() =>
            const Center(child: CircularProgressIndicator()),
          FavoriteError s => ErrorPage(
              errorMessage: s.message,
              onRetry: () =>
                  context.read<FavoriteCubit>().loadFavorites(uid),
            ),
          FavoriteLoaded s => DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: TabBar.secondary(
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.eco_rounded, size: 16),
                              const SizedBox(width: 6),
                              Text(t.favorite.screen.plants_tab(count: s.plants.length)),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.person_rounded, size: 16),
                              const SizedBox(width: 6),
                              Text(t.favorite.screen.users_tab(count: s.users.length)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        FavoritePlantsTab(uid: uid, plants: s.plants),
                        FavoriteUsersTab(uid: uid, users: s.users),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        },
      ),
    );
  }
}
