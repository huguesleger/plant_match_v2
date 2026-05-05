import 'package:fpdart/fpdart.dart';

class UserAuth {
  final String uid;
  final Option<String> email;
  final String fullName;

  UserAuth({
    required this.uid,
    required this.email,
    required this.fullName,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email.toNullable(),
      'fullName': fullName,
    };
  }

  factory UserAuth.fromJson(Map<String, dynamic> json) {
    return UserAuth(
      uid: json['uid'] ?? '',
      email: Option.fromNullable(json['email'] as String?),
      fullName: json['fullName'] ?? '',
    );
  }

/*  UserAuth copyWith({
    String? uid,
    String? email,
    String? fullName,
  }) {
    return UserAuth(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
    );
  }*/
}
