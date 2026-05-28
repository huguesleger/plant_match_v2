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
    final firstName = json['firstName'] as String? ?? '';
    final lastName = json['lastName'] as String? ?? '';
    if (firstName.isEmpty && lastName.isEmpty) {
      final fullName = json['fullName'] as String? ?? '';
      final parts = fullName.trim().split(' ');
      final fName = parts.first;
      final lName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
      return UserAuth(
        uid: json['uid'] ?? '',
        email: Option.fromNullable(json['email'] as String?),
        firstName: fName,
        lastName: lName,
      );
    }
    return UserAuth(
      uid: json['uid'] ?? '',
      email: Option.fromNullable(json['email'] as String?),
      firstName: firstName,
      lastName: lastName,
    );
  }
}
