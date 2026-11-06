import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/util/json_reader.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/failures/failure_mapper.dart';
import 'package:plant_match_v2/core/firebase/cloud_function.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/domain/repository/profil_repository.dart';

class FirebaseProfilRepo implements ProfilRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  TaskEither<Failure, Option<ProfilUser>> getProfilUser(String uid) {
    if (uid.isEmpty) {
      return TaskEither.left(const SessionExpiredFailure('Empty uid'));
    }

    return TaskEither.tryCatch(
      () async {
        final userDoc =
            await _firebaseFirestore.collection('users').doc(uid).get();
        return Option.fromNullable(userDoc.data())
            .filter((_) => userDoc.exists)
            .map((userData) => ProfilUser.fromJson({
                  ...userData,
                  'uid': uid,
                }));
      },
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, Unit> updateProfilUser(ProfilUser updateProfilUser) {
    if (updateProfilUser.uid.isEmpty) {
      return TaskEither.left(const SessionExpiredFailure('Empty uid'));
    }

    return TaskEither.tryCatch(
      () async {
        final data = updateProfilUser.toJson()
          ..remove('uid')
          ..remove('email')
          ..remove('createdAt')
          ..remove('leaves')
          ..remove('referralCode')
          ..remove('referredBy');

        await _firebaseFirestore
            .collection('users')
            .doc(updateProfilUser.uid)
            .update(data);
        return unit;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, Unit> createProfilUser(ProfilUser profilUser) {
    if (profilUser.uid.isEmpty) {
      return TaskEither.left(const SessionExpiredFailure('Empty uid'));
    }

    return TaskEither.tryCatch(
      () async {
        final data = profilUser.toJson()
          ..['leaves'] = 5
          ..remove('email')
          ..remove('referralCode')
          ..remove('referredBy');
        await _firebaseFirestore
            .collection('users')
            .doc(profilUser.uid)
            .set(data);
        return unit;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, Unit> updateProfilField({
    required String uid,
    required String field,
    required dynamic value,
  }) {
    if (uid.isEmpty) {
      return TaskEither.left(const SessionExpiredFailure('Empty uid'));
    }

    return TaskEither.tryCatch(
      () async {
        await _firebaseFirestore.collection('users').doc(uid).update({
          field: value,
        });
        return unit;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, int> applyReferral(String referralCode) =>
      CloudFunction.call('applyReferral', {'code': referralCode})
          .map((result) => result.read<int>('bonus').getOrElse(() => 0));
}
