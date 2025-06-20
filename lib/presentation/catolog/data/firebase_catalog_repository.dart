import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/presentation/catolog/domain/repository/catalog_repository.dart';

class FirebaseCatalogRepository implements CatalogRepository {
  final FirebaseFirestore firestore;

  FirebaseCatalogRepository({FirebaseFirestore? firestoreInstance})
      : firestore = firestoreInstance ?? FirebaseFirestore.instance;

  @override
  Future<void> updateCatalog(Catalog catalog) async {
    if (catalog.catalogId == null) {
      throw Exception('catalogId is required to update a catalog');
    }

    try {
      print(
          "🔥 updateCatalog → ${catalog.catalogId} with data: ${catalog.toJson()}");
      await firestore
          .collection('catalogs')
          .doc(catalog.catalogId)
          .update(catalog.toJson());
    } catch (e) {
      throw Exception('Failed to update catalog: $e');
    }
  }

  @override
  Future<List<Catalog>> getCatalogsByUserId(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('catalogs')
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => Catalog.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch catalogs: $e');
    }
  }

  @override
  Future<Catalog?> getCatalogById(String catalogId) async {
    try {
      final doc = await firestore.collection('catalogs').doc(catalogId).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          return Catalog.fromJson(data);
        }
      }
    } catch (e) {
      throw Exception('Failed to get catalog by ID: $e');
    }
    return null;
  }

  @override
  Future<String> createCatalog(Catalog catalog) async {
    try {
      final docRef =
          await firestore.collection('catalogs').add(catalog.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create catalog: $e');
    }
  }
}
