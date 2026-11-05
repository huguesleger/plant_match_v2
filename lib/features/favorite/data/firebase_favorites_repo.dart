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
      (error, _) =>
          UnexpectedFailure('Erreur lors de l’ajout du favori: $error'),
    );
  }

  @override
  TaskEither<Failure, Unit> removeFavoritePlant(String uid, String catalogId) {
    return TaskEither.tryCatch(
      () async {
        await _plantsRef(uid).doc(catalogId).delete();
        return unit;
      },
      (error, _) =>
          UnexpectedFailure('Erreur lors de la suppression du favori: $error'),
    );
  }

  static const int _whereInLimit = 30;

  Stream<List<T>> _resolveFavorites<T>({
    required CollectionReference favorites,
    required String collection,
    required T Function(Map<String, dynamic> data, String id) parse,
  }) {
    final cache = <String, T>{};
    return favorites
        .orderBy('addedAt', descending: true)
        .snapshots()
        .where((snap) => !snap.metadata.hasPendingWrites)
        .asyncMap((snap) async {
      final ids = snap.docs.map((doc) => doc.id).toList();
      final missing = ids.where((id) => !cache.containsKey(id)).toList();
      final chunks = [
        for (var i = 0; i < missing.length; i += _whereInLimit)
          missing.sublist(i, (i + _whereInLimit).clamp(0, missing.length)),
      ];
      final fetched = await Future.wait(
        chunks.map(
          (chunk) => _db
              .collection(collection)
              .where(FieldPath.documentId, whereIn: chunk)
              .get(),
        ),
      );
      for (final doc in fetched.expand((result) => result.docs)) {
        cache[doc.id] = parse(doc.data(), doc.id);
      }
      return ids
          .map((id) => Option.fromNullable(cache[id]))
          .whereType<Some<T>>()
          .map((found) => found.value)
          .toList();
    });
  }

  @override
  Stream<List<Catalog>> getFavoritePlants(String uid) =>
      _resolveFavorites<Catalog>(
        favorites: _plantsRef(uid),
        collection: 'catalogs',
        parse: Catalog.fromJson,
      ).map(
        (catalogs) => catalogs
            .where((catalog) => catalog.status == CatalogStatus.published)
            .toList(),
      );

  @override
  TaskEither<Failure, bool> isFavoritePlant(String uid, String catalogId) {
    return TaskEither.tryCatch(
      () async {
        final doc = await _plantsRef(uid).doc(catalogId).get();
        return doc.exists;
      },
      (error, _) =>
          UnexpectedFailure('Erreur lors de la vérification du favori: $error'),
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
      (error, _) => UnexpectedFailure(
          'Erreur lors de l’ajout de l’utilisateur favori: $error'),
    );
  }

  @override
  TaskEither<Failure, Unit> removeFavoriteUser(String uid, String targetUid) {
    return TaskEither.tryCatch(
      () async {
        await _usersRef(uid).doc(targetUid).delete();
        return unit;
      },
      (error, _) => UnexpectedFailure(
          'Erreur lors de la suppression de l’utilisateur favori: $error'),
    );
  }

  @override
  Stream<List<ProfilUser>> getFavoriteUsers(String uid) =>
      _resolveFavorites<ProfilUser>(
        favorites: _usersRef(uid),
        collection: 'users',
        parse: (data, id) => ProfilUser.fromJson({...data, 'uid': id}),
      );

  @override
  TaskEither<Failure, bool> isFavoriteUser(String uid, String targetUid) {
    return TaskEither.tryCatch(
      () async {
        final doc = await _usersRef(uid).doc(targetUid).get();
        return doc.exists;
      },
      (error, _) => UnexpectedFailure(
          'Erreur lors de la vérification de l’utilisateur favori: $error'),
    );
  }
}
