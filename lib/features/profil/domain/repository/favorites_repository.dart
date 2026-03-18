import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

abstract class FavoritesRepository {
  TaskEither<Failure, Unit> addFavoritePlant(String uid, Catalog catalog);
  TaskEither<Failure, Unit> removeFavoritePlant(String uid, String catalogId);
  TaskEither<Failure, Unit> addFavoriteUser(String uid, ProfilUser targetUser);
  TaskEither<Failure, Unit> removeFavoriteUser(String uid, String targetUid);
  Stream<List<Map<String, dynamic>>> getFavoritePlantsRaw(String uid);
  Stream<List<ProfilUser>> getFavoriteUsers(String uid);
  TaskEither<Failure, bool> isFavoritePlant(String uid, String catalogId);
  TaskEither<Failure, bool> isFavoriteUser(String uid, String targetUid);
  TaskEither<Failure, bool> checkPlantAvailability(String catalogId);
}
