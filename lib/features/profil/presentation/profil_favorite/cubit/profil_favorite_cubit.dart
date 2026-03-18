import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/profil/domain/repository/favorites_repository.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_favorite/cubit/profil_favorite_state.dart';

class ProfilFavoriteCubit extends Cubit<ProfilFavoriteState> {
  final FavoritesRepository favoritesRepository;

  StreamSubscription<List<Map<String, dynamic>>>? _plantsSub;
  StreamSubscription? _usersSub;

  ProfilFavoriteCubit({required this.favoritesRepository})
      : super(ProfilFavoriteInitial());

  // ─── loadFavorites ─────────────────────────────────────────────────────────

  void loadFavorites(String uid) {
    emit(ProfilFavoriteLoading());

    List<Map<String, dynamic>>? latestPlants;
    List? latestUsers;

    // Stream des plantes favorites avec vérification de disponibilité
    _plantsSub = favoritesRepository.getFavoritePlantsRaw(uid).listen(
      (rawPlants) {
        Future.wait(rawPlants.map((plant) async {
          final catalogId = plant['id'] as String? ?? '';
          final result = await favoritesRepository.checkPlantAvailability(catalogId).run();
          final isAvailable = result.getOrElse((_) => false);
          return {...plant, 'isAvailable': isAvailable};
        })).then((enriched) {
          latestPlants = enriched;

          if (state is ProfilFavoriteLoaded) {
            final current = state as ProfilFavoriteLoaded;
            emit(ProfilFavoriteLoaded(
              plants: enriched,
              users: current.users,
            ));
          } else if (latestUsers != null) {
            emit(ProfilFavoriteLoaded(
              plants: enriched,
              users: latestUsers!.cast(),
            ));
          }
        });
      },
      onError: (e) => emit(ProfilFavoriteError(e.toString())),
    );

    // Stream des profils favoris
    _usersSub = favoritesRepository.getFavoriteUsers(uid).listen(
      (users) {
        latestUsers = users;

        if (state is ProfilFavoriteLoaded) {
          final current = state as ProfilFavoriteLoaded;
          emit(ProfilFavoriteLoaded(
            plants: current.plants,
            users: users,
          ));
        } else if (latestPlants != null) {
          emit(ProfilFavoriteLoaded(
            plants: latestPlants!,
            users: users,
          ));
        }
      },
      onError: (e) => emit(ProfilFavoriteError(e.toString())),
    );
  }

  // ─── removeFavoritePlant ──────────────────────────────────────────────────

  void removeFavoritePlant(String uid, String catalogId) {
    favoritesRepository
        .removeFavoritePlant(uid, catalogId)
        .run()
        .then((result) => result.match(
              (failure) => emit(ProfilFavoriteError(failure.message)),
              (_) => null,
            ));
  }

  // ─── removeFavoriteUser ───────────────────────────────────────────────────

  void removeFavoriteUser(String uid, String targetUid) {
    favoritesRepository
        .removeFavoriteUser(uid, targetUid)
        .run()
        .then((result) => result.match(
              (failure) => emit(ProfilFavoriteError(failure.message)),
              (_) => null,
            ));
  }

  @override
  Future<void> close() {
    _plantsSub?.cancel();
    _usersSub?.cancel();
    return super.close();
  }
}
