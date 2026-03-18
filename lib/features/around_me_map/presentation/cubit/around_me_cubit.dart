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
  }) : super(const AroundMeInitial());

  // ─── getAllUserProfiles ────────────────────────────────────────────────────

  void getAllUserProfiles(String uid) {
    emit(const AroundMeLoading());

    aroundMeRepository
        .getAllUserUids()
        .flatMap((users) => profilRepository.getProfilUser(uid).flatMap(
              (option) => option.match(
                () => TaskEither<Failure, AroundMeState>.left(
                  const AuthFailure('Utilisateur introuvable'),
                ),
                (currentUser) => _getUsersWithCatalogs(users, currentUser),
              ),
            ))
        .match(
          (failure) => AroundMeError(failure.message),
          (state) => state,
        )
        .map(emit)
        .run();
  }

  // ─── fetchConnectedUsers ──────────────────────────────────────────────────

  void fetchConnectedUsers(String uid) {
    emit(const AroundMeLoading());

    aroundMeRepository
        .getAllUserUids()
        .flatMap((users) => profilRepository.getProfilUser(uid).flatMap(
              (option) => option.match(
                () => TaskEither<Failure, AroundMeState>.left(
                  const AuthFailure('Utilisateur introuvable'),
                ),
                (currentUser) {
                  final connectedUsers = users.where((user) => user.uid != uid).toList();
                  return _getUsersWithCatalogs(connectedUsers, currentUser);
                },
              ),
            ))
        .match(
          (failure) => AroundMeError(failure.message),
          (state) => state,
        )
        .map(emit)
        .run();
  }

  // ─── updateUserLocation ───────────────────────────────────────────────────

  void updateUserLocation(ProfilUser updatedUser) {
    emit(const AroundMeLoading());

    aroundMeRepository
        .updateUserLocation(updatedUser)
        .flatMap((_) => aroundMeRepository.getAllUserUids())
        .flatMap((users) => _getUsersWithCatalogs(users, updatedUser))
        .match(
          (failure) => AroundMeError(failure.message),
          (state) => state,
        )
        .map(emit)
        .run();
  }

  // ─── helpers ──────────────────────────────────────────────────────────────

  TaskEither<Failure, AroundMeState> _getUsersWithCatalogs(
    List<ProfilUser> users,
    ProfilUser currentUser,
  ) {
    final catalogTasks = users.map((user) => catalogRepository.getCatalogsByUserId(user.uid)).toList();

    return TaskEither.sequenceList(catalogTasks).map(
      (allCatalogs) {
        final userCatalogs = <String, List<Catalog>>{};
        for (var i = 0; i < users.length; i++) {
          userCatalogs[users[i].uid] = allCatalogs[i];
        }
        return AroundMeLoaded(
          currentUser: currentUser,
          users: users,
          userCatalogs: userCatalogs,
        );
      },
    );
  }
}
