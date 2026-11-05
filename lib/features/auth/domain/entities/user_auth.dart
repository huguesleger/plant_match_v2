import 'package:plant_match_v2/core/util/json_reader.dart';
import 'package:fpdart/fpdart.dart';

class UserAuth {
  final String uid;
  final Option<String> email;
  final String firstName;
  final String lastName;

  UserAuth({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory UserAuth.fromFullName({
    required String uid,
    required Option<String> email,
    required String fullName,
  }) {
    final parts = fullName.trim().split(' ');
    final firstName = parts.first;
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    return UserAuth(
      uid: uid,
      email: email,
      firstName: firstName,
      lastName: lastName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email.toNullable(),
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  factory UserAuth.fromJson(Map<String, dynamic> json) {
    final firstName = json.string('firstName');
    final lastName = json.string('lastName');
    if (firstName.isEmpty && lastName.isEmpty) {
      final fullName = json.string('fullName');
      final parts = fullName.trim().split(' ');
      final fName = parts.first;
      final lName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
      return UserAuth(
        uid: json.string('uid'),
        email: json.read<String>('email'),
        firstName: fName,
        lastName: lName,
      );
    }
    return UserAuth(
      uid: json.string('uid'),
      email: json.read<String>('email'),
      firstName: firstName,
      lastName: lastName,
    );
  }
}
