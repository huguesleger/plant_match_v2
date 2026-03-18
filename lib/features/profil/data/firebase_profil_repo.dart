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
            return Some(ProfilUser(
              uid: uid,
              email: userData['email'],
              fullName: userData['fullName'],
              bio: userData['bio'] ?? '',
              profilImg: userData['profilImg'].toString(),
              userName: userData['userName'] ?? '',
              localisation: userData['localisation'] ?? '',
              country: userData['country'] ?? '',
              zipCode: userData['zipCode'] ?? '',
              birthdayDate: userData['birthdayDate'] != null
                  ? (userData['birthdayDate'] as Timestamp).toDate()
                  : null,
              latitude: userData['latitude'],
              longitude: userData['longitude'],
              position: userData['position'] != null &&
                      userData['position']['geopoint'] != null
                  ? userData['position']['geopoint'] as GeoPoint
                  : const GeoPoint(0, 0),
              isOnline: userData['isOnline'],
            ));
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
        await _firebaseFirestore
            .collection('users')
            .doc(updateProfilUser.uid)
            .update({
          'bio': updateProfilUser.bio,
          'profilImg': updateProfilUser.profilImg,
          'userName': updateProfilUser.userName,
          'localisation': updateProfilUser.localisation,
          'country': updateProfilUser.country,
          'zipCode': updateProfilUser.zipCode,
          'birthdayDate': updateProfilUser.birthdayDate != null
              ? Timestamp.fromDate(updateProfilUser.birthdayDate!)
              : null,
          'latitude': updateProfilUser.latitude,
          'longitude': updateProfilUser.longitude,
          'position': {
            'geopoint': updateProfilUser.position,
          },
          'isOnline': updateProfilUser.isOnline,
        });
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
        await _firebaseFirestore.collection('users').doc(profilUser.uid).set({
          'email': profilUser.email,
          'fullName': profilUser.fullName,
          'bio': profilUser.bio,
          'profilImg': profilUser.profilImg,
          'userName': profilUser.userName,
          'localisation': profilUser.localisation,
          'country': profilUser.country,
          'zipCode': profilUser.zipCode,
          'birthdayDate': profilUser.birthdayDate != null
              ? Timestamp.fromDate(profilUser.birthdayDate!)
              : null,
          'latitude': profilUser.latitude,
          'longitude': profilUser.longitude,
          'position': {
            'geopoint': profilUser.position,
          },
          'isOnline': profilUser.isOnline,
        });
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
