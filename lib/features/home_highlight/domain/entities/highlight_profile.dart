import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class HighlightProfile {
  final String uid;
  final int leaves;
  final String referralCode;
  final bool hasPlants;
  final List<ProfilUser> users;

  const HighlightProfile({
    required this.uid,
    required this.leaves,
    required this.referralCode,
    required this.hasPlants,
    required this.users,
  });

  bool get isOutOfLeaves => leaves <= 0 && referralCode.isNotEmpty;

  Option<ProfilUser> userOf(String userId) =>
      users.where((user) => user.uid == userId).firstOption;
}
