import 'package:flutter_bloc/flutter_bloc.dart';
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

  Future<void> getAllUserProfiles(String uid) async {
    try {
      final users = await aroundMeRepository.getAllUserUids();
      final currentUser = await profilRepository.getProfilUser(uid);

      if (currentUser == null) {
        emit(AroundMeError("Utilisateur introuvable"));
        return;
      }

      final userCatalogs = <String, List<Catalog>>{};
      await Future.wait(users.map((user) async {
        final catalogs = await catalogRepository.getCatalogsByUserId(user.uid);
        userCatalogs[user.uid] = catalogs;
      }));

      emit(AroundMeLoaded(
        currentUser: currentUser,
        users: users,
        userCatalogs: userCatalogs,
      ));
    } catch (e) {
      emit(AroundMeError("Erreur lors du chargement des utilisateurs"));
    }
  }

  Future<void> fetchConnectedUsers(String uid) async {
    try {
      emit(AroundMeLoading());
      final users = await aroundMeRepository.getAllUserUids();
      final currentUser = await profilRepository.getProfilUser(uid);
      final connectedUsers = users.where((user) => user.uid != uid).toList();

      if (currentUser == null) {
        emit(AroundMeError("Utilisateur introuvable"));
        return;
      }

      final userCatalogs = <String, List<Catalog>>{};
      await Future.wait(connectedUsers.map((user) async {
        final catalogs = await catalogRepository.getCatalogsByUserId(user.uid);
        userCatalogs[user.uid] = catalogs;
      }));

      emit(AroundMeLoaded(
          currentUser: currentUser,
          users: connectedUsers,
          userCatalogs: userCatalogs));
    } catch (e) {
      emit(AroundMeError(
          "Erreur lors de la récupération des utilisateurs : $e"));
    }
  }

  void updateUserLocation(ProfilUser updatedUser) async {
    emit(AroundMeLoading());

    try {
      await aroundMeRepository.updateUserLocation(updatedUser);
      final users = await aroundMeRepository.getAllUserUids();

      final userCatalogs = <String, List<Catalog>>{};
      await Future.wait(users.map((user) async {
        final catalogs = await catalogRepository.getCatalogsByUserId(user.uid);
        userCatalogs[user.uid] = catalogs;
      }));

      emit(AroundMeLoaded(
          currentUser: updatedUser, users: users, userCatalogs: userCatalogs));
    } catch (e) {
      emit(AroundMeError("Erreur de mise à jour de la localisation : $e"));
    }
  }
}
