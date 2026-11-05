import 'package:plant_match_v2/core/util/json_reader.dart';
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
    required super.createdAt,
    super.bio = const None(),
    super.birthdayDate = const None(),
    super.leaves = 5,
    super.referralCode = '',
    super.referredBy = const None(),
  });

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    return data;
  }

  factory AroundMe.fromJson(Map<String, dynamic> json) {
    final firstName = json.string('firstName');
    final lastName = json.string('lastName');
    final (fName, lName) = (firstName.isEmpty && lastName.isEmpty)
        ? (() {
            final fullName = json.string('fullName');
            final parts = fullName.trim().split(' ');
            final fn = parts.first;
            final ln = parts.length > 1 ? parts.sublist(1).join(' ') : '';
            return (fn, ln);
          })()
          : (firstName, lastName);

    return AroundMe(
      uid: json.string('uid'),
      email: json.nonEmptyString('email'),
      userName: json.read<String>('userName'),
      latitude: json.decimal('latitude'),
      longitude: json.decimal('longitude'),
      firstName: fName,
      lastName: lName,
      profilImg: json.string('profilImg'),
      localisation: json.string('localisation'),
      country: json.string('country'),
      zipCode: json.string('zipCode'),
      isOnline: json.boolean('isOnline'),
      createdAt: json.date('createdAt').getOrElse(DateTime.now),
      bio: json.read<String>('bio'),
      birthdayDate: json.date('birthdayDate'),
      leaves: json.integer('leaves', 5),
      referralCode: json.string('referralCode'),
      referredBy: json.read<String>('referredBy'),
    );
  }
}
