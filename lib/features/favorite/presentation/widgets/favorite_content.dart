import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/core/widgets/skeleton/app_skeletonizer.dart';
import 'package:plant_match_v2/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:plant_match_v2/features/favorite/presentation/cubit/favorite_state.dart';
import 'package:plant_match_v2/features/favorite/presentation/widgets/favorite_tabs.dart';

class FavoriteContent extends StatelessWidget {
  const FavoriteContent({
    super.key,
    required this.uid,
  });

  final String uid;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) => switch (state) {
          FavoriteInitial() => const SizedBox.shrink(),
          FavoriteLoading(:final plantBoneMocks, :final userBoneMocks) =>
            AppSkeletonizer(
              enabled: true,
              child: FavoriteTabs(
                uid: uid,
                plants: plantBoneMocks,
                users: userBoneMocks,
              ),
            ),
          FavoriteError s => ErrorPage(
              failure: s.failure,
              onRetry: () => context.read<FavoriteCubit>().loadFavorites(uid),
            ),
          FavoriteLoaded s => FavoriteTabs(
              uid: uid,
              plants: s.plants,
              users: s.users,
            ),
        },
      );
}
