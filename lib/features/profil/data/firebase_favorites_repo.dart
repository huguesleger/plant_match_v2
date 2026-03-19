import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
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
  TaskEither<Failure, Unit> addFavoritePlant(String uid, Catalog catalog) {
    return TaskEither.tryCatch(
      () async {
        final id = catalog.catalogId;
        if (id == null) throw Exception('ID catalogue manquant');
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
        return unit;
      },
      (error, _) => UnexpectedFailure('Erreur lors de l’ajout du favori: $error'),
    );
  }

  @override
  TaskEither<Failure, Unit> removeFavoritePlant(String uid, String catalogId) {
    return TaskEither.tryCatch(
      () async {
        await _plantsRef(uid).doc(catalogId).delete();
        return unit;
      },
      (error, _) => UnexpectedFailure('Erreur lors de la suppression du favori: $error'),
    );
  }

  @override
  Stream<List<Map<String, dynamic>>> getFavoritePlantsRaw(String uid) {
    return _plantsRef(uid).orderBy('addedAt', descending: true).snapshots().map(
        (snap) => snap.docs
            .map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>})
            .toList());
  }

  @override
  TaskEither<Failure, bool> isFavoritePlant(String uid, String catalogId) {
    return TaskEither.tryCatch(
      () async {
        final doc = await _plantsRef(uid).doc(catalogId).get();
        return doc.exists;
      },
      (error, _) => UnexpectedFailure('Erreur lors de la vérification du favori: $error'),
    );
  }

  @override
  TaskEither<Failure, bool> checkPlantAvailability(String catalogId) {
    return TaskEither.tryCatch(
      () async {
        if (catalogId.isEmpty) return false;
        final doc = await _db.collection('catalogs').doc(catalogId).get();
        return doc.exists && (doc.data()?['status'] != 'archived');
      },
      (error, _) => UnexpectedFailure('Erreur lors de la vérification de disponibilité: $error'),
    );
  }

  // ─── Profils utilisateurs ───────────────────────────────────────────────────

  @override
  TaskEither<Failure, Unit> addFavoriteUser(String uid, ProfilUser targetUser) {
    return TaskEither.tryCatch(
      () async {
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
        return unit;
      },
      (error, _) => UnexpectedFailure('Erreur lors de l’ajout de l’utilisateur favori: $error'),
    );
  }

  @override
  TaskEither<Failure, Unit> removeFavoriteUser(String uid, String targetUid) {
    return TaskEither.tryCatch(
      () async {
        await _usersRef(uid).doc(targetUid).delete();
        return unit;
      },
      (error, _) => UnexpectedFailure('Erreur lors de la suppression de l’utilisateur favori: $error'),
    );
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
  TaskEither<Failure, bool> isFavoriteUser(String uid, String targetUid) {
    return TaskEither.tryCatch(
      () async {
        final doc = await _usersRef(uid).doc(targetUid).get();
        return doc.exists;
      },
      (error, _) => UnexpectedFailure('Erreur lors de la vérification de l’utilisateur favori: $error'),
    );
  }
}
