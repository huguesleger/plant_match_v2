import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_match_v2/presentation/catolog/domain/repository/catalog_repository.dart';

import '../domain/entity/catalog.dart';
import 'package:uuid/uuid.dart';

class FirebaseCatalogRepository implements CatalogRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  @override
/*  Future<String> createCatalog(Catalog catalog) async {
    final generatedId = _uuid.v4();

    final catalogWithUid = catalog
        .copyWith(
          name: catalog.name,
          description: catalog.description,
          image: catalog.image,
        )
        .copyWith(
          uid: generatedId,
        );

    await _firebaseFirestore
        .collection('catalogs')
        .doc(generatedId)
        .set(catalogWithUid.toJson());

    return generatedId;
  }*/
  Future<String> createCatalog(Catalog catalog) async {
    final newCatalog = catalog.copyWith(
        uid: _uuid.v4()); // Génère un nouvel UID pour le catalogue
    final docRef = await _firebaseFirestore
        .collection('catalogs')
        .add(newCatalog.toJson());
    return docRef.id;
  }

  @override
  Future<List<Catalog>> getUserCatalogs(String userId) async {
    final snapshot = await _firebaseFirestore
        .collection('catalogs')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) => Catalog.fromJson(doc.data())).toList();
  }

  @override /*
  Future<Catalog?> getCatalogById(String uid) async {
    final doc = await _firebaseFirestore.collection('catalogs').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return Catalog.fromJson(doc.data()!);
    }
    return null;
  }*/
  Future<Catalog?> getCatalogById(String uid) async {
    try {
      final docSnapshot =
          await _firebaseFirestore.collection('catalogs').doc(uid).get();
      if (docSnapshot.exists) {
        return Catalog.fromJson(docSnapshot
            .data()!); // Assurez-vous que `Catalog.fromMap` fonctionne correctement
      } else {
        return null; // Si le document n'existe pas, retourne null
      }
    } catch (e) {
      throw Exception("Erreur lors de la récupération du catalogue : $e");
    }
  }

/*  @override
  Future<void> createCatalog(Catalog catalog) async {
    await _firebaseFirestore
        .collection('catalogs')
        .doc(catalog.uid)
        .set(catalog.toJson());
  }*/

  @override
  Future<void> updateCatalog(Catalog catalog) async {
    await _firebaseFirestore
        .collection('catalogs')
        .doc(catalog.uid)
        .update(catalog.toJson());
  }

  @override
  Future<void> deleteCatalog(String uid) async {
    await _firebaseFirestore.collection('catalogs').doc(uid).delete();
  }
}
