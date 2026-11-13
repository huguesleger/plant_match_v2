import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure_mapper.dart';
import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:plant_match_v2/core/widgets/skeleton/skeleton_effect.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/favorite/domain/repository/favorites_repository.dart';
import 'package:plant_match_v2/features/favorite/presentation/cubit/favorite_state.dart';

class FavoriteCubit extends SafeCubit<FavoriteState> {
  final FavoritesRepository favoritesRepository;

  Option<StreamSubscription<List<Catalog>>> _plantsSub = const None();
  Option<StreamSubscription<List<ProfilUser>>> _usersSub = const None();

  FavoriteCubit({required this.favoritesRepository})
      : super(const FavoriteInitial());

  void loadFavorites(String uid) {
    _cancelSubscriptions();
    emit(FavoriteLoading());

    final minimalDelay =
        Future<void>.delayed(SkeletonEffect.shimmerMinimumDelay);
    Option<List<Catalog>> latestPlants = const None();
    Option<List<ProfilUser>> latestUsers = const None();

    void emitWhenBothLoaded() => latestPlants
        .flatMap(
          (plants) => latestUsers.map(
            (users) => FavoriteLoaded(plants: plants, users: users),
          ),
        )
        .map((loaded) => minimalDelay.then((_) => emit(loaded)));

    _plantsSub = Some(favoritesRepository.getFavoritePlants(uid).listen(
      (plants) {
        latestPlants = Some(plants);
        emitWhenBothLoaded();
      },
      onError: _emitError,
    ));

    _usersSub = Some(favoritesRepository.getFavoriteUsers(uid).listen(
      (users) {
        latestUsers = Some(users);
        emitWhenBothLoaded();
      },
      onError: _emitError,
    ));
  }

  void _emitError(Object e) => emit(FavoriteError(mapError(e)));

  void removeFavoritePlant(String uid, String catalogId) {
    favoritesRepository
        .removeFavoritePlant(uid, catalogId)
        .match(
          (failure) => FavoriteError(failure),
          (_) => state,
        )
        .map(emit)
        .run();
  }

  void removeFavoriteUser(String uid, String targetUid) {
    favoritesRepository
        .removeFavoriteUser(uid, targetUid)
        .match(
          (failure) => FavoriteError(failure),
          (_) => state,
        )
        .map(emit)
        .run();
  }

  void _cancelSubscriptions() {
    _plantsSub.map((sub) => sub.cancel());
    _usersSub.map((sub) => sub.cancel());
  }

  @override
  Future<void> close() {
    _cancelSubscriptions();
    return super.close();
  }
}
