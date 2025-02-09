import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_match_v2/presentation/auth/domain/entities/user_auth.dart';

class ProfilUser extends UserAuth {
  final String? bio;
  final String profilImg;
  final String userName;
  final String localisation;
  final String country;
  final DateTime? birthdayDate;
  final double? latitude;
  final double? longitude;
  final GeoPoint position;

  ProfilUser({
    required super.uid,
    required super.email,
    required super.fullName,
    this.bio,
    required this.profilImg,
    required this.userName,
    required this.localisation,
    required this.country,
    this.latitude,
    this.longitude,
    required this.position,
    this.birthdayDate,
  });

  ProfilUser copyWith({
    String? newBio,
    String? newProfilImg,
    String? newUserName,
    String? newLocalisation,
    String? newCountry,
    DateTime? newBirthdayDate,
    double? newLatitude,
    double? newLongitude,
    GeoPoint? newPosition,
  }) {
    return ProfilUser(
      uid: uid,
      email: email,
      fullName: fullName,
      bio: newBio ?? bio,
      profilImg: newProfilImg ?? profilImg,
      userName: newUserName ?? userName,
      localisation: newLocalisation ?? localisation,
      country: newCountry ?? country,
      birthdayDate: newBirthdayDate ?? birthdayDate,
      latitude: newLatitude ?? latitude,
      longitude: newLongitude ?? longitude,
      position: newPosition ?? position,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'bio': bio,
      'profilImg': profilImg,
      'userName': userName,
      'localisation': localisation,
      'country': country,
      'birthdayDate': birthdayDate?.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'position': {
        'geopoint': position,
      },
    };
  }

  factory ProfilUser.fromJson(Map<String, dynamic> json) {
    return ProfilUser(
      uid: json['uid'],
      email: json['email'],
      fullName: json['fullName'],
      bio: json['bio'] ?? '',
      profilImg: json['profilImg'] ?? '',
      userName: json['userName'] ?? '',
      localisation: json['localisation'] ?? '',
      country: json['country'] ?? '',
      birthdayDate: json['birthdayDate'] != null
          ? DateTime.parse(json['birthdayDate'])
          : null,
      latitude: json['latitude'],
      longitude: json['longitude'],
      position: json['position'] != null && json['position']['geopoint'] != null
          ? json['position']['geopoint'] as GeoPoint
          : const GeoPoint(0, 0),
    );
  }
}
