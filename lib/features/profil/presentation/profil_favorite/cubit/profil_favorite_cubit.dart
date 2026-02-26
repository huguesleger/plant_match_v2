import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/profil/domain/repository/favorites_repository.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_favorite/cubit/profil_favorite_state.dart';

class ProfilFavoriteCubit extends Cubit<ProfilFavoriteState> {
  final FavoritesRepository favoritesRepository;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  StreamSubscription<List<Map<String, dynamic>>>? _plantsSub;
  StreamSubscription? _usersSub;

  ProfilFavoriteCubit({required this.favoritesRepository})
      : super(ProfilFavoriteInitial());

  void loadFavorites(String uid) {
    emit(ProfilFavoriteLoading());

    List<List<Map<String, dynamic>>>? latestPlants;
    List? latestUsers;

    // Stream des plantes favorites avec vérification de disponibilité
    _plantsSub = favoritesRepository.getFavoritePlantsRaw(uid).listen(
      (rawPlants) async {
        final enriched = await Future.wait(rawPlants.map((plant) async {
          final catalogId = plant['id'] as String? ?? '';
          bool isAvailable = false;
          if (catalogId.isNotEmpty) {
            final doc = await _db.collection('catalogs').doc(catalogId).get();
            isAvailable = doc.exists && (doc.data()?['status'] != 'archived');
          }
          return {...plant, 'isAvailable': isAvailable};
        }));

        latestPlants = [enriched];

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
            plants: latestPlants!.first,
            users: users,
          ));
        }
      },
      onError: (e) => emit(ProfilFavoriteError(e.toString())),
    );
  }

  Future<void> removeFavoritePlant(String uid, String catalogId) async {
    await favoritesRepository.removeFavoritePlant(uid, catalogId);
  }

  Future<void> removeFavoriteUser(String uid, String targetUid) async {
    await favoritesRepository.removeFavoriteUser(uid, targetUid);
  }

  @override
  Future<void> close() {
    _plantsSub?.cancel();
    _usersSub?.cancel();
    return super.close();
  }
}
