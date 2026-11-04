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
        final data = updateProfilUser.toJson()
          ..remove('uid')
          ..remove('leaves')
          ..remove('referralCode')
          ..remove('referredBy');

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
        await _firebaseFirestore
            .collection('users')
            .doc(profilUser.uid)
            .set(data);
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

  @override
  TaskEither<Failure, Option<ProfilUser>> getProfilUserByReferralCode(
      String referralCode) {
    if (referralCode.isEmpty) {
      return TaskEither.left(const AuthFailure('Code de parrainage vide'));
    }

    return TaskEither.tryCatch(
      () async {
        final querySnapshot = await _firebaseFirestore
            .collection('users')
            .where('referralCode', isEqualTo: referralCode)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final userDoc = querySnapshot.docs.first;
          final userData = userDoc.data();
          return Some(ProfilUser.fromJson({
            ...userData,
            'uid': userDoc.id,
          }));
        }
        return const None();
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  @override
  TaskEither<Failure, Unit> incrementLeaves(String uid, int count) =>
      uid.isEmpty
          ? TaskEither.left(const AuthFailure('UID invalide pour les feuilles'))
          : TaskEither.tryCatch(
              () => _firebaseFirestore.collection('users').doc(uid).update(
                  {'leaves': FieldValue.increment(count)}).then((_) => unit),
              (error, _) => _mapErrorToFailure(error),
            );

  @override
  TaskEither<Failure, Unit> applyReferral({
    required String newUserUid,
    required String referrerUid,
    required String referralCode,
    required int bonus,
  }) =>
      newUserUid.isEmpty || referrerUid.isEmpty
          ? TaskEither.left(
              const AuthFailure('UID invalide pour le parrainage'))
          : TaskEither.tryCatch(
              () {
                final users = _firebaseFirestore.collection('users');
                return (_firebaseFirestore.batch()
                      ..update(users.doc(newUserUid), {
                        'referredBy': referralCode,
                        'leaves': FieldValue.increment(bonus),
                      })
                      ..update(users.doc(referrerUid), {
                        'leaves': FieldValue.increment(bonus),
                      }))
                    .commit()
                    .then((_) => unit);
              },
              (error, _) => _mapErrorToFailure(error),
            );

  Failure _mapErrorToFailure(Object error) {
    if (error is Failure) return error;
    if (error is FirebaseException) {
      return FirebaseFailure('Erreur Firebase: ${error.message ?? error.code}');
    }
    return UnexpectedFailure('Erreur inattendue: $error');
  }
}
