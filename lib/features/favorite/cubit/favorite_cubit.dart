import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/profil/domain/repository/favorites_repository.dart';
import 'package:plant_match_v2/features/favorite/cubit/favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoritesRepository favoritesRepository;

  StreamSubscription<List<Map<String, dynamic>>>? _plantsSub;
  StreamSubscription? _usersSub;

  FavoriteCubit({required this.favoritesRepository})
      : super(const FavoriteInitial());

  void loadFavorites(String uid) {
    emit(const FavoriteLoading());

    List<Map<String, dynamic>>? latestPlants;
    List? latestUsers;

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
            (failure) => emit(FavoriteError(failure.message)),
            (enriched) {
              latestPlants = enriched;

              final currentState = state;
              if (currentState is FavoriteLoaded) {
                emit(FavoriteLoaded(
                  plants: enriched,
                  users: currentState.users,
                ));
              } else if (latestUsers != null) {
                emit(FavoriteLoaded(
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
          emit(FavoriteError(e.toString()));
        }
      },
    );

    _usersSub = favoritesRepository.getFavoriteUsers(uid).listen(
      (users) {
        if (isClosed) return;
        latestUsers = users;

        final currentState = state;
        if (currentState is FavoriteLoaded) {
          emit(FavoriteLoaded(
            plants: currentState.plants,
            users: users,
          ));
        } else if (latestPlants != null) {
          emit(FavoriteLoaded(
            plants: latestPlants!,
            users: users,
          ));
        }
      },
      onError: (e) {
        if (!isClosed) {
          emit(FavoriteError(e.toString()));
        }
      },
    );
  }

  void removeFavoritePlant(String uid, String catalogId) {
    favoritesRepository
        .removeFavoritePlant(uid, catalogId)
        .match(
          (failure) => FavoriteError(failure.message),
          (_) => state,
        )
        .map((s) {
      if (!isClosed) {
        emit(s);
      }
    }).run();
  }

  void removeFavoriteUser(String uid, String targetUid) {
    favoritesRepository
        .removeFavoriteUser(uid, targetUid)
        .match(
          (failure) => FavoriteError(failure.message),
          (_) => state,
        )
        .map((s) {
      if (!isClosed) {
        emit(s);
      }
    }).run();
  }

  @override
  Future<void> close() {
    _plantsSub?.cancel();
    _usersSub?.cancel();
    return super.close();
  }
}
