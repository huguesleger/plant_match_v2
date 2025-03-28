import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/presentation/catolog/domain/repository/catalog_repository.dart';

class FirebaseCatalogRepository implements CatalogRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<void> addCatalog(Catalog catalog) async {
    await _firebaseFirestore
        .collection('catalogs')
        .doc(catalog.uid)
        .set(catalog.toJson());
  }

  @override
  Future<Catalog?> getCatalog(String uid) async {
    try {
      final doc =
          await _firebaseFirestore.collection('catalogs').doc(uid).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data()!;
        data['uid'] = doc.id;
        return Catalog.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateCatalog(Catalog catalog) async {
    await _firebaseFirestore
        .collection('catalogs')
        .doc(catalog.uid)
        .update(catalog.toJson());
  }

  @override
  Future<List<Catalog>> fetchCatalogs(String uid) async {
    try {
      final catalogsCollection = _firebaseFirestore.collection('catalogs');
      final catalogsDocs = await catalogsCollection.get();

      return catalogsDocs.docs.map((doc) {
        Map<String, dynamic> catalogData = doc.data();
        catalogData['uid'] = doc.id;
        return Catalog.fromJson(catalogData);
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
