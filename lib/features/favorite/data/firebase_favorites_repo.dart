import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/favorite/domain/repository/favorites_repository.dart';

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
        final id = catalog.catalogId.toNullable();
        if (id == null) throw Exception('ID catalogue manquant');
        await _plantsRef(uid).doc(id).set({
          'catalogId': id,
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
  Stream<List<Catalog>> getFavoritePlants(String uid) {
    return _plantsRef(uid)
        .orderBy('addedAt', descending: true)
        .snapshots()
        .asyncMap((snap) async {
      final catalogTasks = snap.docs.map((d) async {
        final catalogId = d.id;
        final catalogDoc = await _db.collection('catalogs').doc(catalogId).get();

        if (catalogDoc.exists && catalogDoc.data() != null) {
          return Catalog.fromJson(catalogDoc.data()!, catalogId);
        }
        return null;
      }).toList();

      final results = await Future.wait(catalogTasks);
      return results.whereType<Catalog>().toList();
    });
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



  // ─── Profils utilisateurs ───────────────────────────────────────────────────

  @override
  TaskEither<Failure, Unit> addFavoriteUser(String uid, ProfilUser targetUser) {
    return TaskEither.tryCatch(
      () async {
        await _usersRef(uid).doc(targetUser.uid).set({
          'uid': targetUser.uid,
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
        .asyncMap((snap) async {
      final userTasks = snap.docs.map((d) async {
        final targetUid = d.id;
        final userDoc = await _db.collection('users').doc(targetUid).get();

        if (userDoc.exists && userDoc.data() != null) {
          return ProfilUser.fromJson({
            ...userDoc.data()!,
            'uid': targetUid,
          });
        }
        return null;
      }).toList();

      final results = await Future.wait(userTasks);
      return results.whereType<ProfilUser>().toList();
    });
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
