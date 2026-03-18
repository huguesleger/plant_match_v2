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
      return profilRepository.getProfilUser(uid).flatMap((option) =>
          option.match(
            () => TaskEither.left(const AuthFailure('Utilisateur introuvable')),
            (currentUser) => TaskEither<Failure, AroundMeState>.tryCatch(
              () async {
                final userCatalogs = <String, List<Catalog>>{};
                await Future.wait(users.map((user) async {
                  final catalogsResult =
                      await catalogRepository.getCatalogsByUserId(user.uid).run();
                  userCatalogs[user.uid] = catalogsResult.getOrElse((_) => []);
                }));

                return AroundMeLoaded(
                  currentUser: currentUser,
                  users: users,
                  userCatalogs: userCatalogs,
                );
              },
              (error, _) =>
                  UnexpectedFailure('Erreur lors du chargement: $error'),
            ),
          ));
    }).run().then((result) => result.match(
          (failure) => emit(
              AroundMeError('Erreur lors du chargement des utilisateurs')),
          (state) => emit(state),
        ));
  }

  // ─── fetchConnectedUsers ──────────────────────────────────────────────────

  void fetchConnectedUsers(String uid) {
    emit(AroundMeLoading());

    aroundMeRepository.getAllUserUids().flatMap((users) {
      return profilRepository.getProfilUser(uid).flatMap((option) =>
          option.match(
            () => TaskEither.left(const AuthFailure('Utilisateur introuvable')),
            (currentUser) => TaskEither<Failure, AroundMeState>.tryCatch(
              () async {
                final connectedUsers =
                    users.where((user) => user.uid != uid).toList();

                final userCatalogs = <String, List<Catalog>>{};
                await Future.wait(connectedUsers.map((user) async {
                  final catalogsResult =
                      await catalogRepository.getCatalogsByUserId(user.uid).run();
                  userCatalogs[user.uid] = catalogsResult.getOrElse((_) => []);
                }));

                return AroundMeLoaded(
                  currentUser: currentUser,
                  users: connectedUsers,
                  userCatalogs: userCatalogs,
                );
              },
              (error, _) => UnexpectedFailure(
                  'Erreur lors de la récupération des utilisateurs: $error'),
            ),
          ));
    }).run().then((result) => result.match(
          (failure) => emit(AroundMeError(
              'Erreur lors de la récupération des utilisateurs')),
          (state) => emit(state),
        ));
  }

  // ─── updateUserLocation ───────────────────────────────────────────────────

  void updateUserLocation(ProfilUser updatedUser) {
    emit(AroundMeLoading());

    aroundMeRepository
        .updateUserLocation(updatedUser)
        .flatMap((_) => aroundMeRepository.getAllUserUids())
        .flatMap((users) => TaskEither<Failure, Unit>.tryCatch(
              () async {
                final userCatalogs = <String, List<Catalog>>{};
                await Future.wait(users.map((user) async {
                  final catalogsResult =
                      await catalogRepository.getCatalogsByUserId(user.uid).run();
                  userCatalogs[user.uid] = catalogsResult.getOrElse((_) => []);
                }));

                emit(AroundMeLoaded(
                  currentUser: updatedUser,
                  users: users,
                  userCatalogs: userCatalogs,
                ));
                return unit;
              },
              (error, _) =>
                  UnexpectedFailure('Erreur lors du rechargement: $error'),
            ))
        .run()
        .then((result) => result.match(
              (failure) =>
                  emit(AroundMeError('Erreur de mise à jour de la localisation')),
              (_) => null,
            ));
  }
}
