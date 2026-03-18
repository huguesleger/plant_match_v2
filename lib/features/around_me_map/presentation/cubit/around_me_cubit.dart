import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/around_me_map/domain/repository/around_me_repository.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_state.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catolog/domain/repository/catalog_repository.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/domain/repository/profil_repository.dart';

class AroundMeCubit extends Cubit<AroundMeState> {
  final AroundMeRepository aroundMeRepository;
  final ProfilRepository profilRepository;
  final CatalogRepository catalogRepository;

  AroundMeCubit({
    required this.aroundMeRepository,
    required this.profilRepository,
    required this.catalogRepository,
  }) : super(AroundMeInitial());

  // ─── getAllUserProfiles ────────────────────────────────────────────────────

  void getAllUserProfiles(String uid) {
    emit(AroundMeLoading());

    aroundMeRepository.getAllUserUids().flatMap((users) {
      return profilRepository.getProfilUser(uid).flatMap((option) => option.match(
            () => TaskEither.left(const AuthFailure('Utilisateur introuvable')),
            (currentUser) {
              final catalogTasks = users
                  .map((user) => catalogRepository.getCatalogsByUserId(user.uid))
                  .toList();

              return TaskEither.sequenceList(catalogTasks).map((allCatalogs) {
                final userCatalogs = <String, List<Catalog>>{};
                for (var i = 0; i < users.length; i++) {
                  userCatalogs[users[i].uid] = allCatalogs[i];
                }
                return AroundMeLoaded(
                  currentUser: currentUser,
                  users: users,
                  userCatalogs: userCatalogs,
                );
              });
            },
          ));
    }).match<AroundMeState>(
      (failure) => AroundMeError('Erreur lors du chargement des utilisateurs'),
      (state) => state,
    ).map((s) => emit(s)).run();
  }

  // ─── fetchConnectedUsers ──────────────────────────────────────────────────

  void fetchConnectedUsers(String uid) {
    emit(AroundMeLoading());

    aroundMeRepository.getAllUserUids().flatMap((users) {
      return profilRepository.getProfilUser(uid).flatMap((option) => option.match(
            () => TaskEither.left(const AuthFailure('Utilisateur introuvable')),
            (currentUser) {
              final connectedUsers =
                  users.where((user) => user.uid != uid).toList();

              final catalogTasks = connectedUsers
                  .map((user) => catalogRepository.getCatalogsByUserId(user.uid))
                  .toList();

              return TaskEither.sequenceList(catalogTasks).map((allCatalogs) {
                final userCatalogs = <String, List<Catalog>>{};
                for (var i = 0; i < connectedUsers.length; i++) {
                  userCatalogs[connectedUsers[i].uid] = allCatalogs[i];
                }
                return AroundMeLoaded(
                  currentUser: currentUser,
                  users: connectedUsers,
                  userCatalogs: userCatalogs,
                );
              });
            },
          ));
    }).match<AroundMeState>(
      (failure) => AroundMeError(
          'Erreur lors de la récupération des utilisateurs'),
      (state) => state,
    ).map((s) => emit(s)).run();
  }

  // ─── updateUserLocation ───────────────────────────────────────────────────

  void updateUserLocation(ProfilUser updatedUser) {
    emit(AroundMeLoading());

    aroundMeRepository
        .updateUserLocation(updatedUser)
        .flatMap((_) => aroundMeRepository.getAllUserUids())
        .flatMap((users) {
      final catalogTasks = users
          .map((user) => catalogRepository.getCatalogsByUserId(user.uid))
          .toList();

      return TaskEither.sequenceList(catalogTasks).map((allCatalogs) {
        final userCatalogs = <String, List<Catalog>>{};
        for (var i = 0; i < users.length; i++) {
          userCatalogs[users[i].uid] = allCatalogs[i];
        }
        return AroundMeLoaded(
          currentUser: updatedUser,
          users: users,
          userCatalogs: userCatalogs,
        );
      });
    }).match<AroundMeState>(
      (failure) =>
          AroundMeError('Erreur de mise à jour de la localisation'),
      (state) => state,
    ).map((s) => emit(s)).run();
  }
}
