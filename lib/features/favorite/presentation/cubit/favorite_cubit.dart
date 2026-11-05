import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/favorite/domain/repository/favorites_repository.dart';
import 'package:plant_match_v2/features/favorite/presentation/cubit/favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoritesRepository favoritesRepository;

  Option<StreamSubscription<List<Catalog>>> _plantsSub = const None();
  Option<StreamSubscription<List<ProfilUser>>> _usersSub = const None();

  FavoriteCubit({required this.favoritesRepository})
      : super(const FavoriteInitial());

  void loadFavorites(String uid) {
    _plantsSub.map((sub) => sub.cancel());
    _usersSub.map((sub) => sub.cancel());
    emit(const FavoriteLoading());

    Option<List<Catalog>> latestPlants = const None();
    Option<List<ProfilUser>> latestUsers = const None();

    _plantsSub = Some(favoritesRepository.getFavoritePlants(uid).listen(
      (plants) {
        if (isClosed) return;
        latestPlants = Some(plants);

        final currentState = state;
        if (currentState is FavoriteLoaded) {
          emit(FavoriteLoaded(
            plants: plants,
            users: currentState.users,
          ));
        } else {
          latestUsers.match(
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
    ));

    _usersSub = Some(favoritesRepository.getFavoriteUsers(uid).listen(
      (users) {
        if (isClosed) return;
        latestUsers = Some(users);

        final currentState = state;
        if (currentState is FavoriteLoaded) {
          emit(FavoriteLoaded(
            plants: currentState.plants,
            users: users,
          ));
        } else {
          latestPlants.match(
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
    ));
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
    _plantsSub.map((sub) => sub.cancel());
    _usersSub.map((sub) => sub.cancel());
    return super.close();
  }
}
