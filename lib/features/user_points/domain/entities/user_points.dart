class UserPoints {
  final int currentPoints;
  final String uid;
  final int level;

  const UserPoints({
    required this.currentPoints,
    required this.uid,
    required this.level,
  });

  /// Crée une copie de UserPoints avec les champs modifiés
  UserPoints copyWith({
    int? currentPoints,
    String? uid,
    int? level,
  }) {
    return UserPoints(
      currentPoints: currentPoints ?? this.currentPoints,
      uid: uid ?? this.uid,
      level: level ?? this.level,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPoints': currentPoints,
      'uid': uid,
      'level': level,
    };
  }

  factory UserPoints.fromJson(Map<String, dynamic> json) {
    return UserPoints(
      currentPoints: json['currentPoints'] as int,
      uid: json['uid'] as String,
      level: json['level'] as int,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserPoints &&
        other.currentPoints == currentPoints &&
        other.uid == uid &&
        other.level == level;
  }

  @override
  int get hashCode => Object.hash(currentPoints, uid, level);

  @override
  String toString() =>
      'UserPoints(uid: $uid, currentPoints: $currentPoints, level: $level)';
}
