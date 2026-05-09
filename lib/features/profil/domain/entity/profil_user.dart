import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/auth/domain/entities/user_auth.dart';

class ProfilUser extends UserAuth {
  final Option<String> bio;
  final String profilImg;
  final Option<String> userName;
  final String localisation;
  final String country;
  final String zipCode;
  final Option<DateTime> birthdayDate;
  final Option<double> latitude;
  final Option<double> longitude;
  final bool isOnline;

  ProfilUser({
    required super.uid,
    required super.email,
    required super.fullName,
    required this.bio,
    required this.profilImg,
    required this.userName,
    required this.localisation,
    required this.country,
    required this.zipCode,
    required this.birthdayDate,
    required this.latitude,
    required this.longitude,
    required this.isOnline,
  });

  ProfilUser copyWith({
    Option<String>? newBio,
    String? newProfilImg,
    Option<String>? newUserName,
    String? newLocalisation,
    String? newZipCode,
    String? newCountry,
    Option<DateTime>? newBirthdayDate,
    Option<double>? newLatitude,
    Option<double>? newLongitude,
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
      isOnline: newIsOnline ?? isOnline,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email.toNullable(),
      'fullName': fullName,
      'bio': bio.toNullable(),
      'profilImg': profilImg,
      'userName': userName.toNullable(),
      'localisation': localisation,
      'country': country,
      'zipCode': zipCode,
      'birthdayDate': birthdayDate.match(
        () => null,
        (date) => Timestamp.fromDate(date),
      ),
      'latitude': latitude.toNullable(),
      'longitude': longitude.toNullable(),
      'isOnline': isOnline,
    };
  }

  factory ProfilUser.fromJson(Map<String, dynamic> json) {
    Option<String> stringToOption(dynamic value) {
      final s = value as String?;
      if (s == null || s.trim().isEmpty) return const None();
      return Some(s);
    }

    return ProfilUser(
      uid: json['uid'] ?? '',
      email: Option.fromNullable(json['email'] as String?),
      fullName: json['fullName'] ?? '',
      bio: stringToOption(json['bio']),
      profilImg: json['profilImg'] ?? '',
      userName: stringToOption(json['userName']),
      localisation: json['localisation'] ?? '',
      country: json['country'] ?? '',
      zipCode: json['zipCode'] ?? '',
      birthdayDate: Option.fromNullable(json['birthdayDate']).map((d) {
        if (d is Timestamp) return d.toDate();
        if (d is String) return DateTime.tryParse(d) ?? DateTime.now();
        return DateTime.now();
      }),
      latitude: Option.fromNullable(json['latitude']?.toDouble()),
      longitude: Option.fromNullable(json['longitude']?.toDouble()),
      isOnline: json['isOnline'] ?? false,
    );
  }
}
