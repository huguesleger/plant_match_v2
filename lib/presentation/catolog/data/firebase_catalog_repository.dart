import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/presentation/catolog/domain/repository/catalog_repository.dart';

class FirebaseCatalogRepository implements CatalogRepository {
  final FirebaseFirestore firestore;

  FirebaseCatalogRepository({FirebaseFirestore? firestoreInstance})
      : firestore = firestoreInstance ?? FirebaseFirestore.instance;

  @override
  Future<String> createEmptyCatalog(String userId) async {
    try {
      final newDocRef = firestore.collection('catalogs').doc();
      final emptyCatalog = Catalog(
        uid: newDocRef.id,
        userId: userId,
        name: '',
        description: '',
        images: [],
        environment: null,
        family: [],
        levelMaintenance: null,
        watering: null,
        lighting: null,
      );
      await newDocRef.set(emptyCatalog.toJson());
      return newDocRef.id;
    } catch (e) {
      throw Exception('Failed to create empty catalog: $e');
    }
  }

  @override
  Future<void> updateCatalog(Catalog catalog) async {
    try {
      await firestore.collection('catalogs').doc(catalog.uid).set(
            catalog.toJson(),
            SetOptions(merge: true),
          );
    } catch (e) {
      throw Exception('Failed to update catalog: $e');
    }
  }

  @override
  Future<List<Catalog>> getCatalogsByUserId(String userId) async {
    try {
      final query = await firestore
          .collection('catalogs')
          .where('userId', isEqualTo: userId)
          .get();
      return query.docs.map((doc) => Catalog.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to get catalogs by user ID: $e');
    }
  }

  @override
  Future<Catalog?> getCatalogById(String catalogId) async {
    try {
      final doc = await firestore.collection('catalogs').doc(catalogId).get();
      if (!doc.exists) return null;
      return Catalog.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to get catalog by ID: $e');
    }
  }

  @override
  Future<void> deleteCatalog(String catalogId) async {
    try {
      await firestore.collection('catalogs').doc(catalogId).delete();
    } catch (e) {
      throw Exception('Failed to delete catalog: $e');
    }
  }
}
