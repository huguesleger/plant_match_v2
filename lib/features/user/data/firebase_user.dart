import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/user/domain/repository/user_repository.dart';

class FirebaseUser implements UserRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  TaskEither<Failure, ProfilUser> getUserUid(String uid) {
    return TaskEither.tryCatch(
      () async {
        final userDoc =
            await _firebaseFirestore.collection('users').doc(uid).get();

        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data()!;
          userData['uid'] = userDoc.id;
          return ProfilUser.fromJson(userData);
        } else {
          throw const NotFoundFailure('Pas d\'utilisateur trouvé avec cet UID');
        }
      },
      (error, stackTrace) {
        if (error is NotFoundFailure) {
          return error;
        }
        return FirebaseFailure(
            'Erreur lors de la récupération de l\'utilisateur : $error');
      },
    );
  }
}
