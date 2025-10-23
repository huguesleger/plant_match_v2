class UserPoints {
  final int currentPoints;
  final String uid;
  final int level;

  UserPoints({
    required this.currentPoints,
    required this.uid,
    required this.level,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPoints': currentPoints,
      'uid': uid,
      'level': level,
    };
  }

  factory UserPoints.fromJson(Map<String, dynamic> json) {
    return UserPoints(
      currentPoints: json['currentPoints'],
      uid: json['uid'],
      level: json['level'],
    );
  }
}
