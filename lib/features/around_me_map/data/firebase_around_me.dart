import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:plant_match_v2/features/around_me_map/domain/repository/around_me_repository.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class FirebaseAroundMe implements AroundMeRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final Distance _distance = const Distance();

  @override
  Future<List<ProfilUser>> getAllUserUids() async {
    try {
      final usersCollection = _firebaseFirestore.collection('users');
      final usersDocs = await usersCollection.get();

      List<ProfilUser> userProfiles = usersDocs.docs.map((doc) {
        Map<String, dynamic> userData = doc.data();
        userData['uid'] = doc.id;
        return ProfilUser.fromJson(userData);
      }).toList();

      return userProfiles;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> updateUserLocation(ProfilUser user) async {
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    await userRef.update({
      'latitude': user.latitude,
      'longitude': user.longitude,
      'localisation': user.localisation,
      'country': user.country,
    });
  }
}
