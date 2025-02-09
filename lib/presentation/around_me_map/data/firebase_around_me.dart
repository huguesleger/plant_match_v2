import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_match_v2/presentation/around_me_map/domain/entity/around_me.dart';
import 'package:plant_match_v2/presentation/around_me_map/domain/repository/around_me_repository.dart';

class FirebaseAroundMe implements AroundMeRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<List<AroundMe>> getAllUsers(String currentUserId) async {
    try {
      final querySnapshot = await _firebaseFirestore
          .collection('users')
/*          .where('uid', isNotEqualTo: currentUserId)*/
          .get();

      return querySnapshot.docs
          .map((doc) => _mapDocumentToAroundMe(doc))
          .where((user) => user.latitude != null && user.longitude != null)
          .toList();
    } catch (e) {
      throw Exception("Erreur lors de la récupération des utilisateurs : $e");
    }
  }

  @override
  Future<List<AroundMe>> getPlacesAroundMe(
      String uid, double latitude, double longitude) async {
    try {
      final querySnapshot = await _firebaseFirestore.collection('users').get();

      return querySnapshot.docs
          .map((doc) => _mapDocumentToAroundMe(doc))
          .where((user) => user.latitude != null && user.longitude != null)
          .toList();
    } catch (e) {
      throw Exception(
          "Erreur lors de la récupération des utilisateurs proches : $e");
    }
  }

  // 🔹 Fonction privée pour mapper un document Firestore à un objet AroundMe
  AroundMe _mapDocumentToAroundMe(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return AroundMe(
      uid: data['uid']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      userName: data['userName']?.toString() ?? '',
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
      fullName: data['fullName']?.toString() ?? '',
      profilImg: data['profilImg']?.toString() ?? '',
      localisation: data['localisation']?.toString() ?? '',
      country: data['country']?.toString() ?? '',
      position:
          data['position']?['geopoint'] as GeoPoint? ?? const GeoPoint(0, 0),
    );
  }
}
