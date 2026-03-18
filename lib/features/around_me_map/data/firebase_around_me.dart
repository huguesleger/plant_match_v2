import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/around_me_map/domain/repository/around_me_repository.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class FirebaseAroundMe implements AroundMeRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  TaskEither<Failure, List<ProfilUser>> getAllUserUids() {
    return TaskEither.tryCatch(
      () async {
        final usersDocs =
            await _firebaseFirestore.collection('users').get();

        return usersDocs.docs.map((doc) {
          final userData = doc.data();
          userData['uid'] = doc.id;
          return ProfilUser.fromJson(userData);
        }).toList();
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  @override
  TaskEither<Failure, Unit> updateUserLocation(ProfilUser user) {
    return TaskEither.tryCatch(
      () async {
        await _firebaseFirestore
            .collection('users')
            .doc(user.uid)
            .update({
          'latitude': user.latitude,
          'longitude': user.longitude,
          'localisation': user.localisation,
          'country': user.country,
        });
        return unit;
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  Failure _mapErrorToFailure(Object error) {
    if (error is Failure) return error;
    if (error is FirebaseException) {
      return FirebaseFailure(
          'Erreur Firebase: ${error.message ?? error.code}');
    }
    return UnexpectedFailure('Erreur inattendue: $error');
  }
}
