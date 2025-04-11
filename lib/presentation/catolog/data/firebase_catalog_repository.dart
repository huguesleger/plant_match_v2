import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/presentation/catolog/domain/repository/catalog_repository.dart';

class FirebaseCatalogRepository implements CatalogRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> createCatalog(Catalog catalog) async {
    try {
      // Crée un document dans Firestore avec les données du catalog
      await _firestore.collection('catalogs').doc(catalog.uid).set({
        'uid': catalog.uid,
        'name': catalog.name,
        'description': catalog.description,
        'images': catalog.images,
        'environment': catalog.environment.name,
        'family': catalog.family.name,
        'levelMaintenance': catalog.levelMaintenance.name,
        'watering': catalog.watering.name,
        'lighting': catalog.lighting.name,
      });

      print("Catalog successfully created in Firebase!");
    } catch (e) {
      print("Error creating catalog: $e");
      throw Exception("Failed to create catalog: $e");
    }
  }

  @override
  Future<Catalog?> getCatalog(String uid) async {
    try {
      final catalogDoc = await _firestore.collection('catalogs').doc(uid).get();

      if (catalogDoc.exists) {
        final catalogData = catalogDoc.data();

        if (catalogData != null) {
          return Catalog(
            uid: uid,
            name: catalogData['name'],
            description: catalogData['description'],
            images: List<String>.from(catalogData['images']),
            environment: Environment.values.byName(catalogData['environment']),
            family: Family.values.byName(catalogData['family']),
            levelMaintenance:
                LevelMaintenance.values.byName(catalogData['levelMaintenance']),
            watering: Watering.values.byName(catalogData['watering']),
            lighting: Lighting.values.byName(catalogData['lighting']),
          );
        }
      }
    } catch (e) {
      print("Error retrieving catalog: $e");
      return null;
    }
    return null;
  }

  @override
  Future<void> updateCatalog(Catalog catalog) async {
    try {
      // Utilise Firebase Firestore pour mettre à jour le document du catalogue
      final catalogRef =
          FirebaseFirestore.instance.collection('catalogs').doc(catalog.uid);

      // Mettre à jour le champ 'name' (et autres champs si nécessaire)
      await catalogRef.update({
        'name': catalog.name,
        'description': catalog.description,
        'images': catalog.images,
        'environment': catalog.environment.name,
        'family': catalog.family.name,
        'levelMaintenance': catalog.levelMaintenance.name,
        'watering': catalog.watering.name,
        'lighting': catalog.lighting.name,
        // Ajouter d'autres champs à mettre à jour ici si nécessaire
      });
    } catch (e) {
      throw Exception("Erreur lors de la mise à jour du catalogue : $e");
    }
  }

  @override
  Future<void> updateImageCatalog(
      String catalogId, List<String> imageUrls) async {
    try {
      final catalogRef =
          FirebaseFirestore.instance.collection('catalogs').doc(catalogId);

      await catalogRef.update({
        'images': imageUrls,
      });

      print("✅ Images mises à jour dans Firebase: $imageUrls");
    } catch (e) {
      print("❌ Erreur lors de la mise à jour des images: $e");
      throw Exception("Erreur lors de la mise à jour des images");
    }
  }
}
