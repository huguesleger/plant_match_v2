import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/favorite/domain/repository/favorites_repository.dart';
import 'package:plant_match_v2/features/favorite/presentation/cubit/favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoritesRepository favoritesRepository;

  StreamSubscription<List<Catalog>>? _plantsSub;
  StreamSubscription<List<ProfilUser>>? _usersSub;

  FavoriteCubit({required this.favoritesRepository})
      : super(const FavoriteInitial());

  void loadFavorites(String uid) {
    emit(const FavoriteLoading());

    List<Catalog>? latestPlants;
    List<ProfilUser>? latestUsers;

    _plantsSub = favoritesRepository.getFavoritePlants(uid).listen(
      (plants) {
        if (isClosed) return;
        latestPlants = plants;

        final currentState = state;
        if (currentState is FavoriteLoaded) {
          emit(FavoriteLoaded(
            plants: plants,
            users: currentState.users,
          ));
        } else {
          Option.fromNullable(latestUsers).match(
            () => {},
            (users) => emit(FavoriteLoaded(
              plants: plants,
              users: users,
            )),
          );
        }
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
        } else {
          Option.fromNullable(latestPlants).match(
            () => {},
            (plants) => emit(FavoriteLoaded(
              plants: plants,
              users: users,
            )),
          );
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
