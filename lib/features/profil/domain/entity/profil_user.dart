import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_match_v2/features/auth/domain/entities/user_auth.dart';

class ProfilUser extends UserAuth {
  final String? bio;
  final String profilImg;
  final String userName;
  final String localisation;
  final String country;
  final String zipCode;
  final DateTime? birthdayDate;
  final double? latitude;
  final double? longitude;
  final GeoPoint position;
  final bool isOnline;

  ProfilUser({
    required super.uid,
    required super.email,
    required super.fullName,
    this.bio,
    required this.profilImg,
    required this.userName,
    required this.localisation,
    required this.country,
    required this.zipCode,
    this.latitude,
    this.longitude,
    required this.position,
    this.birthdayDate,
    required this.isOnline,
  });

  ProfilUser copyWith({
    String? newBio,
    String? newProfilImg,
    String? newUserName,
    String? newLocalisation,
    String? newZipCode,
    String? newCountry,
    DateTime? newBirthdayDate,
    double? newLatitude,
    double? newLongitude,
    GeoPoint? newPosition,
    bool? newIsOnline,
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
      zipCode: newZipCode ?? zipCode,
      birthdayDate: newBirthdayDate ?? birthdayDate,
      latitude: newLatitude ?? latitude,
      longitude: newLongitude ?? longitude,
      position: newPosition ?? position,
      isOnline: newIsOnline ?? isOnline,
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
      'zipCode': zipCode,
      'birthdayDate': birthdayDate?.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'position': {
        'geopoint': position,
      },
      'isOnline': isOnline,
    };
  }

  factory ProfilUser.fromJson(Map<String, dynamic> json) {
    return ProfilUser(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      bio: json['bio'] ?? '',
      profilImg: json['profilImg'] ?? '',
      userName: json['userName'] ?? '',
      localisation: json['localisation'] ?? '',
      country: json['country'] ?? '',
      zipCode: json['zipCode'] ?? '',
      birthdayDate: json['birthdayDate'] != null
          ? (json['birthdayDate'] is Timestamp
              ? (json['birthdayDate'] as Timestamp).toDate()
              : DateTime.tryParse(json['birthdayDate'].toString()))
          : null,
      latitude: (json['latitude'] != null) ? json['latitude'].toDouble() : 0.0,
      longitude:
          (json['longitude'] != null) ? json['longitude'].toDouble() : 0.0,
      position: json['position'] != null && json['position']['geopoint'] != null
          ? json['position']['geopoint'] as GeoPoint
          : const GeoPoint(0, 0),
      isOnline: json['isOnline'] ?? false,
    );
  }
}
