import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/domain/repository/catalog_repository.dart';

class FirebaseCatalogRepository implements CatalogRepository {
  final FirebaseFirestore firestore;

  FirebaseCatalogRepository({FirebaseFirestore? firestoreInstance})
      : firestore = firestoreInstance ?? FirebaseFirestore.instance;

  @override
  TaskEither<Failure, Unit> updateCatalog(Catalog catalog) {
    return catalog.catalogId.match(
      () => TaskEither.left(
        const UnexpectedFailure('catalogId is required to update a catalog'),
      ),
      (id) => TaskEither.tryCatch(
        () async {
          final data = catalog.toJson();
          data.remove('createdAt');

          await firestore.collection('catalogs').doc(id).update(data);
          return unit;
        },
        (error, _) => _mapErrorToFailure(error),
      ),
    );
  }

  @override
  TaskEither<Failure, List<Catalog>> getCatalogsByUserId(String userId) {
    return TaskEither.tryCatch(
      () async {
        final querySnapshot = await firestore
            .collection('catalogs')
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .get();

        return querySnapshot.docs
            .map((doc) => Catalog.fromJson(doc.data(), doc.id))
            .toList();
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  @override
  TaskEither<Failure, Option<Catalog>> getCatalogById(String catalogId) {
    return TaskEither.tryCatch(
      () async {
        final doc = await firestore.collection('catalogs').doc(catalogId).get();
        if (doc.exists) {
          final data = doc.data();
          if (data != null) {
            return Some(Catalog.fromJson(data, doc.id));
          }
        }
        return const None();
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  @override
  TaskEither<Failure, String> createCatalog(Catalog catalog) {
    return TaskEither.tryCatch(
      () async {
        final data = catalog.toJson();
        data['createdAt'] = FieldValue.serverTimestamp();
        final docRef = await firestore.collection('catalogs').add(data);
        return docRef.id;
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  @override
  TaskEither<Failure, Unit> deleteCatalog(String catalogId) {
    return TaskEither.tryCatch(
      () async {
        await firestore.collection('catalogs').doc(catalogId).delete();
        return unit;
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  @override
  Stream<Catalog?> watchCatalog(String catalogId) {
    return firestore
        .collection('catalogs')
        .doc(catalogId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      final data = doc.data();
      if (data == null) return null;

      return Catalog.fromJson(data, doc.id);
    });
  }

  @override
  Stream<List<Catalog>> watchCatalogsByUserId(String userId) {
    return firestore
        .collection('catalogs')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((query) => query.docs
            .map((doc) => Catalog.fromJson(doc.data(), doc.id))
            .toList());
  }

  @override
  TaskEither<Failure, Unit> incrementCatalogViews(String catalogId) {
    return TaskEither.tryCatch(
      () async {
        await firestore.collection('catalogs').doc(catalogId).update({
          'views': FieldValue.increment(1),
        });
        return unit;
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  Failure _mapErrorToFailure(Object error) {
    if (error is Failure) return error;
    if (error is FirebaseException) {
      return FirebaseFailure('Erreur Firebase: ${error.message ?? error.code}');
    }
    return UnexpectedFailure('Erreur inattendue: $error');
  }
}
