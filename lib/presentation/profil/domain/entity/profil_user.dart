import 'package:plant_match_v2/presentation/auth/domain/entities/user_auth.dart';

class ProfilUser extends UserAuth {
  final String bio;
  final String profilImg;
  final String userName;
  final String localisation;
  final String country;
  final DateTime birthdayDate;

  ProfilUser({
    required super.uid,
    required super.email,
    required super.fullName,
    required this.bio,
    required this.profilImg,
    required this.userName,
    required this.localisation,
    required this.country,
    required this.birthdayDate,
  });

  ProfilUser copyWith({
    String? newBio,
    String? newProfilImg,
    String? newUserName,
    String? newLocalisation,
    String? newCountry,
    DateTime? newBirthdayDate,
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
      'birthdayDate': birthdayDate.toIso8601String(),
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
      birthdayDate: DateTime.parse(
          json['birthdayDate'] ?? DateTime.now().toIso8601String()),
    );
  }
}
