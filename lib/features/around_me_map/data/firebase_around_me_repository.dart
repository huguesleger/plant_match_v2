import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/util/distance/distance_helper.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/around_me_map/domain/repository/around_me_repository.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class FirebaseAroundMeRepository implements AroundMeRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  static const int _whereInLimit = 30;

  @override
  TaskEither<Failure, List<ProfilUser>> getUsersByIds(Set<String> uids) =>
      TaskEither.tryCatch(
        () async {
          final ids = uids.toList();
          final chunks = [
            for (var i = 0; i < ids.length; i += _whereInLimit)
              ids.sublist(i, (i + _whereInLimit).clamp(0, ids.length)),
          ];
          final snapshots = await Future.wait(
            chunks.map(
              (chunk) => _firebaseFirestore
                  .collection('users')
                  .where(FieldPath.documentId, whereIn: chunk)
                  .get(),
            ),
          );
          return snapshots
              .expand((snapshot) => snapshot.docs)
              .map((doc) => ProfilUser.fromJson({...doc.data(), 'uid': doc.id}))
              .toList();
        },
        (error, _) => _mapErrorToFailure(error),
      );

  @override
  TaskEither<Failure, Unit> updateUserLocation(ProfilUser user) {
    return TaskEither.tryCatch(
      () async {
        await _firebaseFirestore.collection('users').doc(user.uid).update({
          'latitude': user.latitude.map(DistanceHelper.coarse).toNullable(),
          'longitude': user.longitude.map(DistanceHelper.coarse).toNullable(),
          'localisation': user.localisation,
          'country': user.country,
          'zipCode': user.zipCode,
        });
        return unit;
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  Failure _mapErrorToFailure(Object error) {
    if (error is Failure) return error;
    if (error is FirebaseException) {
      return FirebaseFailure('Erreur Firebase: ${Option.fromNullable(error.message).getOrElse(() => error.code)}');
    }
    return UnexpectedFailure('Erreur inattendue: $error');
  }
}
