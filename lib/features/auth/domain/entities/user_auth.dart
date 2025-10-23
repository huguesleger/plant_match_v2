class UserAuth {
  final String uid;
  final String? email;
  final String fullName;

  UserAuth({
    required this.uid,
    required this.email,
    required this.fullName,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
    };
  }

  factory UserAuth.fromJson(Map<String, dynamic> json) {
    return UserAuth(
      uid: json['uid'],
      email: json['email'],
      fullName: json['fullName'],
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
