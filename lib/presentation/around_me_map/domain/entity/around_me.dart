import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_match_v2/presentation/profil/domain/entity/profil_user.dart';

class AroundMe extends ProfilUser {
  AroundMe({
    required super.uid,
    required super.email,
    required super.userName,
    required super.latitude,
    required super.longitude,
    required super.fullName,
    required super.profilImg,
    required super.localisation,
    required super.country,
    required super.position,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'userName': userName,
      'latitude': latitude,
      'longitude': longitude,
      'fullName': fullName,
      'profilImg': profilImg,
      'localisation': localisation,
      'country': country,
      'position': {
        'geopoint': position,
      },
    };
  }

  factory AroundMe.fromJson(Map<String, dynamic> json) {
    return AroundMe(
      uid: json['uid'],
      email: json['email'],
      userName: json['userName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      fullName: json['fullName'],
      profilImg: json['profilImg'],
      localisation: json['localisation'],
      country: json['country'],
      position: json['position'] != null && json['position']['geopoint'] != null
          ? json['position']['geopoint'] as GeoPoint
          : const GeoPoint(0, 0),
    );
  }
}
