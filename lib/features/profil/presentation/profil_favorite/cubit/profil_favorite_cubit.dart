import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/profil/domain/repository/favorites_repository.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_favorite/cubit/profil_favorite_state.dart';

class ProfilFavoriteCubit extends Cubit<ProfilFavoriteState> {
  final FavoritesRepository favoritesRepository;

  StreamSubscription<List<Map<String, dynamic>>>? _plantsSub;
  StreamSubscription? _usersSub;

  ProfilFavoriteCubit({required this.favoritesRepository})
      : super(const ProfilFavoriteInitial());

  // ─── loadFavorites ─────────────────────────────────────────────────────────

  void loadFavorites(String uid) {
    emit(const ProfilFavoriteLoading());

    List<Map<String, dynamic>>? latestPlants;
    List? latestUsers;

    // Stream des plantes favorites avec vérification de disponibilité
    _plantsSub = favoritesRepository.getFavoritePlantsRaw(uid).listen(
      (rawPlants) {
        final checkTasks = rawPlants.map((plant) {
          final catalogId = plant['id'] as String? ?? '';
          return favoritesRepository
              .checkPlantAvailability(catalogId)
              .map((isAvailable) => {...plant, 'isAvailable': isAvailable});
        }).toList();

        TaskEither.sequenceList(checkTasks).run().then((result) {
          if (isClosed) return;

          result.match(
            (failure) => emit(ProfilFavoriteError(failure.message)),
            (enriched) {
              latestPlants = enriched;

              final currentState = state;
              if (currentState is ProfilFavoriteLoaded) {
                emit(ProfilFavoriteLoaded(
                  plants: enriched,
                  users: currentState.users,
                ));
              } else if (latestUsers != null) {
                emit(ProfilFavoriteLoaded(
                  plants: enriched,
                  users: latestUsers!.cast(),
                ));
              }
            },
          );
        });
      },
      onError: (e) {
        if (!isClosed) {
          emit(ProfilFavoriteError(e.toString()));
        }
      },
    );

    // Stream des profils favoris
    _usersSub = favoritesRepository.getFavoriteUsers(uid).listen(
      (users) {
        if (isClosed) return;
        latestUsers = users;

        final currentState = state;
        if (currentState is ProfilFavoriteLoaded) {
          emit(ProfilFavoriteLoaded(
            plants: currentState.plants,
            users: users,
          ));
        } else if (latestPlants != null) {
          emit(ProfilFavoriteLoaded(
            plants: latestPlants!,
            users: users,
          ));
        }
      },
      onError: (e) {
        if (!isClosed) {
          emit(ProfilFavoriteError(e.toString()));
        }
      },
    );
  }

  // ─── removeFavoritePlant ──────────────────────────────────────────────────

  void removeFavoritePlant(String uid, String catalogId) {
    favoritesRepository
        .removeFavoritePlant(uid, catalogId)
        .match(
          (failure) => ProfilFavoriteError(failure.message),
          (_) => state,
        )
        .map((s) {
          if (!isClosed) {
            emit(s);
          }
        })
        .run();
  }

  // ─── removeFavoriteUser ───────────────────────────────────────────────────

  void removeFavoriteUser(String uid, String targetUid) {
    favoritesRepository
        .removeFavoriteUser(uid, targetUid)
        .match(
          (failure) => ProfilFavoriteError(failure.message),
          (_) => state,
        )
        .map((s) {
          if (!isClosed) {
            emit(s);
          }
        })
        .run();
  }

  @override
  Future<void> close() {
    _plantsSub?.cancel();
    _usersSub?.cancel();
    return super.close();
  }
}
