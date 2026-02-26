import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/domain/repository/favorites_repository.dart';

class FirebaseFavoritesRepo implements FavoritesRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference _plantsRef(String uid) =>
      _db.collection('users').doc(uid).collection('favorites_plants');

  CollectionReference _usersRef(String uid) =>
      _db.collection('users').doc(uid).collection('favorites_users');

  // ─── Plantes ────────────────────────────────────────────────────────────────

  @override
  Future<void> addFavoritePlant(String uid, Catalog catalog) async {
    final id = catalog.catalogId;
    if (id == null) return;
    await _plantsRef(uid).doc(id).set({
      'catalogId': id,
      'name': catalog.name,
      'imageUrl': catalog.images.isNotEmpty ? catalog.images.first : '',
      'offerType': catalog.offerType.name,
      'environment': catalog.environment.name,
      'description': catalog.description,
      'userId': catalog.userId,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removeFavoritePlant(String uid, String catalogId) async {
    await _plantsRef(uid).doc(catalogId).delete();
  }

  /// Retourne un stream de maps brutes (avec vérification disponibilité faite côté cubit)
  @override
  Stream<List<Map<String, dynamic>>> getFavoritePlantsRaw(String uid) {
    return _plantsRef(uid).orderBy('addedAt', descending: true).snapshots().map(
        (snap) => snap.docs
            .map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>})
            .toList());
  }

  @override
  Future<bool> isFavoritePlant(String uid, String catalogId) async {
    final doc = await _plantsRef(uid).doc(catalogId).get();
    return doc.exists;
  }

  // ─── Profils utilisateurs ───────────────────────────────────────────────────

  @override
  Future<void> addFavoriteUser(String uid, ProfilUser targetUser) async {
    await _usersRef(uid).doc(targetUser.uid).set({
      'uid': targetUser.uid,
      'fullName': targetUser.fullName,
      'userName': targetUser.userName,
      'profilImg': targetUser.profilImg,
      'localisation': targetUser.localisation,
      'zipCode': targetUser.zipCode,
      'isOnline': targetUser.isOnline,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removeFavoriteUser(String uid, String targetUid) async {
    await _usersRef(uid).doc(targetUid).delete();
  }

  @override
  Stream<List<ProfilUser>> getFavoriteUsers(String uid) {
    return _usersRef(uid)
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) {
              final data = d.data() as Map<String, dynamic>;
              return ProfilUser(
                uid: data['uid'] ?? '',
                email: '',
                fullName: data['fullName'] ?? '',
                bio: '',
                profilImg: data['profilImg'] ?? '',
                userName: data['userName'] ?? '',
                localisation: data['localisation'] ?? '',
                country: '',
                zipCode: data['zipCode'] ?? '',
                position: const GeoPoint(0, 0),
                isOnline: data['isOnline'] ?? false,
              );
            }).toList());
  }

  @override
  Future<bool> isFavoriteUser(String uid, String targetUid) async {
    final doc = await _usersRef(uid).doc(targetUid).get();
    return doc.exists;
  }
}
