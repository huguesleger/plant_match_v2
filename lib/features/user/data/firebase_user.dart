import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/user/domain/repository/user_repository.dart';

class FirebaseUser implements UserRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ProfilUser> getUserUid(String uid) async {
    try {
      final userDoc =
          await _firebaseFirestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data()!;
        userData['uid'] = userDoc.id;
        return ProfilUser.fromJson(userData);
      } else {
        throw Exception('Pas d\'utilisateur trouvé avec cet UID');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'utilisateur : $e');
    }
  }
}
