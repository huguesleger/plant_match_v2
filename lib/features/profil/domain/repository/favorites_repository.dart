import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

abstract class FavoritesRepository {
  Future<void> addFavoritePlant(String uid, Catalog catalog);
  Future<void> removeFavoritePlant(String uid, String catalogId);
  Future<void> addFavoriteUser(String uid, ProfilUser targetUser);
  Future<void> removeFavoriteUser(String uid, String targetUid);
  Stream<List<Map<String, dynamic>>> getFavoritePlantsRaw(String uid);
  Stream<List<ProfilUser>> getFavoriteUsers(String uid);
  Future<bool> isFavoritePlant(String uid, String catalogId);
  Future<bool> isFavoriteUser(String uid, String targetUid);
}
