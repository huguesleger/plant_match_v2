import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/favorite/data/firebase_favorites_repo.dart';
import 'package:plant_match_v2/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:plant_match_v2/features/favorite/presentation/favorite_screen.dart';

class FavoritePageRoute extends StatelessWidget {
  FavoritePageRoute({super.key});

  final favoritesRepository = FirebaseFavoritesRepo();

  @override
  Widget build(BuildContext context) {
    return context.read<AuthCubit>().userId.match(
      () => Scaffold(
        body: Center(child: Text(t.common.notConnected)),
      ),
      (userId) => BlocProvider(
        create: (context) =>
            FavoriteCubit(favoritesRepository: favoritesRepository)
              ..loadFavorites(userId),
        child: FavoriteScreen(uid: userId),
      ),
    );
  }
}
