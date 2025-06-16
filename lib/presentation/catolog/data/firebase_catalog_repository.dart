import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_match_v2/presentation/catolog/domain/repository/catalog_repository.dart';

import '../domain/entity/catalog.dart';

class FirebaseCatalogRepository implements CatalogRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> createCatalog(Catalog catalog) async {
    try {
      // Générer un nouvel UID pour ce catalogue
      final newDocRef = FirebaseFirestore.instance.collection('catalogs').doc();

      // Ajouter l'UID généré au catalogue
      final newCatalog = catalog.copyWith(uid: newDocRef.id);

      // Enregistrer le catalogue dans Firestore
      await newDocRef.set(newCatalog.toJson());
    } catch (e) {
      print("Erreur lors de la création du catalogue: $e");
      throw Exception("Erreur lors de la création du catalogue");
    }
  }

  @override
  Future<void> updateCatalog(Catalog catalog) async {
    try {
      await firestore.collection('catalogs').doc(catalog.uid).set(
            catalog.toJson(),
            SetOptions(merge: true), // crée ou met à jour le doc
          );
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du catalogue : $e');
    }
  }

  @override
  Future<List<Catalog>> getCatalogsByUserId(String userId) async {
    final querySnapshot = await firestore
        .collection('catalogs')
        .where('userId', isEqualTo: userId)
        .get();

    return querySnapshot.docs
        .map((doc) => Catalog.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<Catalog?> getCatalogById(String catalogId) async {
    final doc = await firestore.collection('catalogs').doc(catalogId).get();
    if (doc.exists) {
      return Catalog.fromJson(doc.data()!);
    }
    return null;
  }

  @override
  Future<void> deleteCatalog(String catalogId) async {
    await firestore.collection('catalogs').doc(catalogId).delete();
  }
}
