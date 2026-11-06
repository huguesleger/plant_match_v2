import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/failures/failure_mapper.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/domain/repository/catalog_repository.dart';

class FirebaseCatalogRepository implements CatalogRepository {
  final FirebaseFirestore firestore;

  FirebaseCatalogRepository(
      {Option<FirebaseFirestore> firestoreInstance = const None()})
      : firestore =
            firestoreInstance.getOrElse(() => FirebaseFirestore.instance);

  @override
  TaskEither<Failure, Unit> updateCatalog(Catalog catalog) {
    return catalog.catalogId.match(
      () => TaskEither.left(
        const UnexpectedFailure('catalogId is required to update a catalog'),
      ),
      (id) => TaskEither.tryCatch(
        () async {
          final data = catalog.toJson()
            ..remove('createdAt')
            ..remove('views')
            ..remove('userId');

          await firestore.collection('catalogs').doc(id).update(data);
          return unit;
        },
        (error, _) => mapError(error),
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
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, Option<Catalog>> getCatalogById(String catalogId) {
    return TaskEither.tryCatch(
      () async {
        final doc = await firestore.collection('catalogs').doc(catalogId).get();
        if (!doc.exists) return const None();
        return Option.fromNullable(doc.data())
            .map((data) => Catalog.fromJson(data, doc.id));
      },
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, String> createCatalog(Catalog catalog) {
    return TaskEither.tryCatch(
      () async {
        final data = catalog.toJson();
        data['createdAt'] = FieldValue.serverTimestamp();
        final docRef = catalog.catalogId.match(
          () => firestore.collection('catalogs').doc(),
          (id) => firestore.collection('catalogs').doc(id),
        );
        await docRef.set(data);
        return docRef.id;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, List<Catalog>> getPublishedCatalogs({
    required int limit,
  }) =>
      TaskEither.tryCatch(
        () async => (await firestore
                .collection('catalogs')
                .where('status', isEqualTo: CatalogStatus.published.name)
                .orderBy('createdAt', descending: true)
                .limit(limit)
                .get())
            .docs
            .map((doc) => Catalog.fromJson(doc.data(), doc.id))
            .toList(),
        (error, _) => mapError(error),
      );

  @override
  String reserveCatalogId() => firestore.collection('catalogs').doc().id;

  @override
  TaskEither<Failure, Unit> deleteCatalog(String catalogId) {
    return TaskEither.tryCatch(
      () async {
        await firestore.collection('catalogs').doc(catalogId).delete();
        return unit;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  Stream<Option<Catalog>> watchCatalog(String catalogId) {
    return firestore
        .collection('catalogs')
        .doc(catalogId)
        .snapshots()
        .map(
          (doc) => Option.fromNullable(doc.data())
              .map((data) => Catalog.fromJson(data, doc.id)),
        );
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
      (error, _) => mapError(error),
    );
  }
}
