import 'package:plant_match_v2/core/util/json_reader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/util/distance/distance_helper.dart';
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
  final DateTime createdAt;
  final int leaves;
  final String referralCode;
  final Option<String> referredBy;

  ProfilUser({
    required super.uid,
    required super.email,
    required super.firstName,
    required super.lastName,
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
    required this.createdAt,
    required this.leaves,
    required this.referralCode,
    required this.referredBy,
  });

  ProfilUser copyWith({
    Option<String> newFirstName = const None(),
    Option<String> newLastName = const None(),
    Option<Option<String>> newBio = const None(),
    Option<String> newProfilImg = const None(),
    Option<Option<String>> newUserName = const None(),
    Option<String> newLocalisation = const None(),
    Option<String> newZipCode = const None(),
    Option<String> newCountry = const None(),
    Option<Option<DateTime>> newBirthdayDate = const None(),
    Option<Option<double>> newLatitude = const None(),
    Option<Option<double>> newLongitude = const None(),
    Option<bool> newIsOnline = const None(),
    Option<DateTime> newCreatedAt = const None(),
    Option<int> newLeaves = const None(),
    Option<String> newReferralCode = const None(),
    Option<Option<String>> newReferredBy = const None(),
  }) {
    return ProfilUser(
      uid: uid,
      email: email,
      firstName: newFirstName.getOrElse(() => firstName),
      lastName: newLastName.getOrElse(() => lastName),
      bio: newBio.getOrElse(() => bio),
      profilImg: newProfilImg.getOrElse(() => profilImg),
      userName: newUserName.getOrElse(() => userName),
      localisation: newLocalisation.getOrElse(() => localisation),
      country: newCountry.getOrElse(() => country),
      zipCode: newZipCode.getOrElse(() => zipCode),
      birthdayDate: newBirthdayDate.getOrElse(() => birthdayDate),
      latitude: newLatitude.getOrElse(() => latitude),
      longitude: newLongitude.getOrElse(() => longitude),
      isOnline: newIsOnline.getOrElse(() => isOnline),
      createdAt: newCreatedAt.getOrElse(() => createdAt),
      leaves: newLeaves.getOrElse(() => leaves),
      referralCode: newReferralCode.getOrElse(() => referralCode),
      referredBy: newReferredBy.getOrElse(() => referredBy),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email.toNullable(),
      'firstName': firstName,
      'lastName': lastName,
      'bio': bio.toNullable(),
      'profilImg': profilImg,
      'userName': userName.toNullable(),
      'localisation': localisation,
      'country': country,
      'zipCode': zipCode,
      'birthdayDate': birthdayDate.map(Timestamp.fromDate).toNullable(),
      'latitude': latitude.map(DistanceHelper.coarse).toNullable(),
      'longitude': longitude.map(DistanceHelper.coarse).toNullable(),
      'isOnline': isOnline,
      'createdAt': Timestamp.fromDate(createdAt),
      'leaves': leaves,
      'referralCode': referralCode,
      'referredBy': referredBy.toNullable(),
    };
  }

  factory ProfilUser.fromJson(Map<String, dynamic> json) {
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

    return ProfilUser(
      uid: json.string('uid'),
      email: json.read<String>('email'),
      firstName: fName,
      lastName: lName,
      bio: json.nonEmptyString('bio'),
      profilImg: json.string('profilImg'),
      userName: json.nonEmptyString('userName'),
      localisation: json.string('localisation'),
      country: json.string('country'),
      zipCode: json.string('zipCode'),
      birthdayDate: json.date('birthdayDate'),
      latitude: json.decimal('latitude'),
      longitude: json.decimal('longitude'),
      isOnline: json.boolean('isOnline'),
      createdAt: json.date('createdAt').getOrElse(DateTime.now),
      leaves: json.integer('leaves', 5),
      referralCode: json.string('referralCode'),
      referredBy: json.read<String>('referredBy'),
    );
  }
}
