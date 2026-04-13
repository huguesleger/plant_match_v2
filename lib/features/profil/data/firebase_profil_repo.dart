import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/domain/repository/profil_repository.dart';

class FirebaseProfilRepo implements ProfilRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  TaskEither<Failure, Option<ProfilUser>> getProfilUser(String uid) {
    if (uid.isEmpty) {
      return TaskEither.left(const AuthFailure('UID invalide'));
    }

    return TaskEither.tryCatch(
      () async {
        final userDoc =
            await _firebaseFirestore.collection('users').doc(uid).get();
        if (userDoc.exists) {
          final userData = userDoc.data();

          if (userData != null) {
            return Some(ProfilUser.fromJson({
              ...userData,
              'uid': uid, 
            }));
          }
        }
        return const None();
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  @override
  TaskEither<Failure, Unit> updateProfilUser(ProfilUser updateProfilUser) {
    if (updateProfilUser.uid.isEmpty) {
      return TaskEither.left(
          const AuthFailure('UID invalide pour la mise à jour du profil'));
    }

    return TaskEither.tryCatch(
      () async {
        final data = updateProfilUser.toJson();
        data.remove('uid');
        
        await _firebaseFirestore
            .collection('users')
            .doc(updateProfilUser.uid)
            .update(data);
        return unit;
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  @override
  TaskEither<Failure, Unit> createProfilUser(ProfilUser profilUser) {
    if (profilUser.uid.isEmpty) {
      return TaskEither.left(
          const AuthFailure('UID invalide pour la création du profil'));
    }

    return TaskEither.tryCatch(
      () async {
        final data = profilUser.toJson();
        await _firebaseFirestore.collection('users').doc(profilUser.uid).set(data);
        return unit;
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  @override
  TaskEither<Failure, Unit> updateProfilField({
    required String uid,
    required String field,
    required dynamic value,
  }) {
    if (uid.isEmpty) {
      return TaskEither.left(
          const AuthFailure('UID invalide pour la mise à jour du champ'));
    }

    return TaskEither.tryCatch(
      () async {
        await _firebaseFirestore.collection('users').doc(uid).update({
          field: value,
        });
        return unit;
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  Failure _mapErrorToFailure(Object error) {
    if (error is Failure) return error;
    if (error is FirebaseException) {
      return FirebaseFailure('Erreur Firebase: ${error.message ?? error.code}');
    }
    return UnexpectedFailure('Erreur inattendue: $error');
  }
}
