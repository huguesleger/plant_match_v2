import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_match_v2/presentation/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/presentation/profil/domain/repository/profil_repository.dart';

class FirebaseProfilRepo implements ProfilRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ProfilUser?> getProfilUser(String uid) async {
    try {
      final userDoc =
          await _firebaseFirestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data();

        if (userData != null) {
          return ProfilUser(
            uid: uid,
            email: userData['email'],
            fullName: userData['fullName'],
            bio: userData['bio'] ?? '',
            profilImg: userData['profilImg'].toString(),
            userName: userData['userName'] ?? '',
            localisation: userData['localisation'] ?? '',
            country: userData['country'] ?? '',
            birthdayDate: userData['birthdayDate'] != null
                ? (userData['birthdayDate'] as Timestamp).toDate()
                : null,
            latitude: userData['latitude'],
            longitude: userData['longitude'],
            position: userData['position'] != null &&
                    userData['position']['geopoint'] != null
                ? userData['position']['geopoint'] as GeoPoint
                : const GeoPoint(0, 0),
          );
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  @override
  Future<void> updateProfilUser(ProfilUser updateProfilUser) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(updateProfilUser.uid)
          .update({
        'bio': updateProfilUser.bio,
        'profilImg': updateProfilUser.profilImg,
        'userName': updateProfilUser.userName,
        'localisation': updateProfilUser.localisation,
        'country': updateProfilUser.country,
        'birthdayDate': updateProfilUser.birthdayDate != null
            ? Timestamp.fromDate(updateProfilUser.birthdayDate!)
            : null,
        'latitude': updateProfilUser.latitude,
        'longitude': updateProfilUser.longitude,
        'position': {
          'geopoint': updateProfilUser.position,
        },
      });
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du profil');
    }
  }

  @override
  Future<void> createProfilUser(ProfilUser profilUser) async {
    try {
      await _firebaseFirestore.collection('users').doc(profilUser.uid).set({
        'email': profilUser.email,
        'fullName': profilUser.fullName,
        'bio': profilUser.bio,
        'profilImg': profilUser.profilImg,
        'userName': profilUser.userName,
        'localisation': profilUser.localisation,
        'country': profilUser.country,
        'birthdayDate': profilUser.birthdayDate != null
            ? Timestamp.fromDate(profilUser.birthdayDate!)
            : null,
        'latitude': profilUser.latitude,
        'longitude': profilUser.longitude,
        'position': {
          'geopoint': profilUser.position,
        },
      });
    } catch (e) {
      throw Exception('Erreur lors de la création du profil');
    }
  }
}
