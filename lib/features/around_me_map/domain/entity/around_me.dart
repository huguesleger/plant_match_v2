import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class AroundMe extends ProfilUser {
  AroundMe({
    required super.uid,
    required super.email,
    required super.userName,
    required super.latitude,
    required super.longitude,
    required super.firstName,
    required super.lastName,
    required super.profilImg,
    required super.localisation,
    required super.country,
    required super.zipCode,
    required super.isOnline,
    super.bio = const None(),
    super.birthdayDate = const None(),
  });

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    return data;
  }

  factory AroundMe.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName'] as String? ?? '';
    final lastName = json['lastName'] as String? ?? '';
    final (fName, lName) = (firstName.isEmpty && lastName.isEmpty)
        ? (() {
            final fullName = json['fullName'] as String? ?? '';
            final parts = fullName.trim().split(' ');
            final fn = parts.first;
            final ln = parts.length > 1 ? parts.sublist(1).join(' ') : '';
            return (fn, ln);
          })()
        : (firstName, lastName);

    return AroundMe(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      userName: Option.fromNullable(json['userName'] as String?),
      latitude: Option.fromNullable(json['latitude']?.toDouble()),
      longitude: Option.fromNullable(json['longitude']?.toDouble()),
      firstName: fName,
      lastName: lName,
      profilImg: json['profilImg'] ?? '',
      localisation: json['localisation'] ?? '',
      country: json['country'] ?? '',
      zipCode: json['zipCode'] ?? '',
      isOnline: json['isOnline'] ?? false,
      bio: Option.fromNullable(json['bio'] as String?),
      birthdayDate: Option.fromNullable(json['birthdayDate']).map((d) {
        if (d is Timestamp) return d.toDate();
        if (d is String) return DateTime.tryParse(d) ?? DateTime.now();
        return DateTime.now();
      }),
    );
  }
}
