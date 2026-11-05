import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/util/json_reader.dart';
import 'package:plant_match_v2/features/auth/domain/entities/user_auth.dart';
import 'package:plant_match_v2/features/auth/domain/repository/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;

  FirebaseAuthRepository()
      : this.using(
          firebaseAuth: FirebaseAuth.instance,
          firebaseFirestore: FirebaseFirestore.instance,
          googleSignIn: GoogleSignIn(),
          facebookAuth: FacebookAuth.instance,
        );

  FirebaseAuthRepository.using({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
    required GoogleSignIn googleSignIn,
    required FacebookAuth facebookAuth,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore,
        _googleSignIn = googleSignIn,
        _facebookAuth = facebookAuth;

  static T _required<T>(Option<T> value, String message) =>
      value.getOrElse(() => throw AuthFailure(message));

  @override
  TaskEither<Failure, Option<UserAuth>> getCurrentUser() {
    return TaskEither.tryCatch(
      () async {
        return Option.fromNullable(_firebaseAuth.currentUser).match(
          () async => const None(),
          (firebaseUser) async {
            final userDoc = await _firebaseFirestore
                .collection('users')
                .doc(firebaseUser.uid)
                .get();
            return Option.fromNullable(userDoc.data()).map(
              (data) => UserAuth.fromJson({
                ...data,
                'uid': firebaseUser.uid,
                'email': firebaseUser.email,
              }),
            );
          },
        );
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  @override
  TaskEither<Failure, UserAuth> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return TaskEither.tryCatch(
      () async {
        final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        final user = _required(
          Option.fromNullable(userCredential.user),
          'Une erreur inattendue est survenue. Veuillez réessayer.',
        );

        final userRef = _firebaseFirestore.collection('users').doc(user.uid);
        final data = Option.fromNullable((await userRef.get()).data())
            .getOrElse(() => throw const AuthProfileMissingFailure());

        await userRef.update({'isOnline': true});

        return UserAuth.fromJson({
          ...data,
          'uid': user.uid,
          'email': user.email,
        });
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  @override
  TaskEither<Failure, UserAuth> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) {
    return TaskEither.tryCatch(
      () async {
        final userCredential = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);

        final user = _required(
          Option.fromNullable(userCredential.user),
          "Impossible de créer l'utilisateur.",
        );
        await user.updateDisplayName('$firstName $lastName'.trim());

        return UserAuth(
          email: Option.fromNullable(email),
          uid: user.uid,
          firstName: firstName,
          lastName: lastName,
        );
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  @override
  TaskEither<Failure, bool> finalizeRegistration(
    User user,
    String firstName,
    String lastName,
  ) {
    return TaskEither.tryCatch(
      () async {
        final docRef = _firebaseFirestore.collection('users').doc(user.uid);
        final existingDoc = await docRef.get();
        if (existingDoc.exists) return false;

        await docRef.set({
          'firstName': firstName,
          'lastName': lastName,
          'isOnline': true,
          'createdAt': FieldValue.serverTimestamp(),
          'emailVerified': true,
          'leaves': 5,
        });
        return true;
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  @override
  TaskEither<Failure, (UserAuth, bool)> signInWithGoogle() {
    return TaskEither.tryCatch(
      () async {
        final googleUser = _required(
          Option.fromNullable(await _googleSignIn.signIn()),
          'Connexion avec Google annulée.',
        );

        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = _required(
          Option.fromNullable(userCredential.user),
          "Échec de l'authentification avec Google.",
        );

        final userAuth = UserAuth.fromFullName(
          email: Option.fromNullable(firebaseUser.email),
          uid: firebaseUser.uid,
          fullName: Option.fromNullable(firebaseUser.displayName).getOrElse(() => ''),
        );

        final docRef = _firebaseFirestore.collection('users').doc(userAuth.uid);
        final docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          await docRef.update({'isOnline': true});
          return (_withStoredNames(userAuth, Option.fromNullable(docSnapshot.data())), false);
        } else {
          await docRef.set({
            'firstName': userAuth.firstName,
            'lastName': userAuth.lastName,
            'isOnline': true,
            'createdAt': FieldValue.serverTimestamp(),
            'emailVerified': true,
            'leaves': 5,
          });
          return (userAuth, true);
        }
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  @override
  TaskEither<Failure, (UserAuth, bool)> signInWithFacebook() {
    return TaskEither.tryCatch(
      () async {
        final nonce = DateTime.now().toIso8601String();
        final result = await _facebookAuth.login(
          permissions: ['public_profile', 'email'],
          loginTracking: LoginTracking.enabled,
          nonce: nonce,
        );

        if (result.status != LoginStatus.success) {
          throw const AuthFailure('Connexion avec Facebook annulée.');
        }

        final userData = await _facebookAuth.getUserData();
        final accessToken = _required(
          Option.fromNullable(result.accessToken),
          'Connexion avec Facebook annulée.',
        );
        final credential =
            FacebookAuthProvider.credential(accessToken.tokenString);
        await AppTrackingTransparency.requestTrackingAuthorization();

        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = _required(
          Option.fromNullable(userCredential.user),
          "Échec de l'authentification avec Facebook.",
        );

        final userAuth = UserAuth.fromFullName(
          email: userData.read<String>('email'),
          uid: firebaseUser.uid,
          fullName: userData.string('name'),
        );

        final docRef = _firebaseFirestore.collection('users').doc(userAuth.uid);
        final docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          await docRef.update({'isOnline': true});
          return (_withStoredNames(userAuth, Option.fromNullable(docSnapshot.data())), false);
        } else {
          await docRef.set({
            'firstName': userAuth.firstName,
            'lastName': userAuth.lastName,
            'isOnline': true,
            'createdAt': FieldValue.serverTimestamp(),
            'emailVerified': true,
            'leaves': 5,
          });
          return (userAuth, true);
        }
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  @override
  TaskEither<Failure, Unit> logOut() {
    return TaskEither.tryCatch(
      () async {
        try {
          await _googleSignIn.signOut();
        } catch (_) {}

        try {
          await _facebookAuth.logOut();
        } catch (_) {}

        try {
          await Option.fromNullable(_firebaseAuth.currentUser).match(
            () async {},
            (user) => _firebaseFirestore
                .collection('users')
                .doc(user.uid)
                .update({'isOnline': false}),
          );
        } on FirebaseException catch (e) {
          if (e.code != 'not-found') {
            debugPrint(
                'Note: Impossible de mettre à jour le statut online: $e');
          }
        } catch (e) {
          debugPrint('Note: Impossible de mettre à jour le statut online: $e');
        }

        await _firebaseAuth.signOut();
        return unit;
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  @override
  TaskEither<Failure, Unit> sendPasswordResetEmail({required String email}) {
    return TaskEither.tryCatch(
      () async {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
        return unit;
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  @override
  TaskEither<Failure, Unit> sendEmailVerification() {
    return TaskEither.tryCatch(
      () async {
        await _required(
          Option.fromNullable(_firebaseAuth.currentUser),
          "Aucun utilisateur connecté. Impossible d'envoyer le mail de vérification.",
        ).reload();
        final user = _required(
          Option.fromNullable(_firebaseAuth.currentUser),
          'Aucun utilisateur après reload. Réessayez.',
        );
        if (user.emailVerified) {
          throw const AuthFailure('Email déjà vérifié.');
        }

        await user.sendEmailVerification();
        return unit;
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  @override
  TaskEither<Failure, bool> isEmailVerified() {
    return TaskEither.tryCatch(
      () async {
        await _required(
          Option.fromNullable(_firebaseAuth.currentUser),
          'Aucun utilisateur connecté.',
        ).reload();
        return Option.fromNullable(_firebaseAuth.currentUser)
            .map((user) => user.emailVerified)
            .getOrElse(() => false);
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  UserAuth _withStoredNames(UserAuth user, Option<Map<String, dynamic>> data) =>
      data
          .map((d) => (
                d.nonEmptyString('firstName'),
                d.nonEmptyString('lastName'),
              ))
          .filter((names) => names.$1.isSome() || names.$2.isSome())
          .match(
            () => user,
            (names) => UserAuth(
              uid: user.uid,
              email: user.email,
              firstName: names.$1.getOrElse(() => user.firstName),
              lastName: names.$2.getOrElse(() => user.lastName),
            ),
          );

  static const _authMessages = {
    'user-not-found': 'Aucun compte trouvé pour cet email.',
    'wrong-password': 'Mot de passe incorrect.',
    'invalid-email': 'Email invalide.',
    'user-disabled': 'Ce compte a été désactivé.',
    'invalid-credential': 'Les informations de connexion sont incorrectes.',
  };

  Failure _mapErrorToFailure(Object error) {
    if (error is Failure) return error;

    if (error is FirebaseAuthException) {
      final message = Option.fromNullable(_authMessages[error.code]).getOrElse(
        () => 'Une erreur inattendue est survenue. Veuillez réessayer.',
      );
      return AuthFailure(message);
    }

    if (error is FirebaseException) {
      return FirebaseFailure(
          'Erreur Firebase: ${Option.fromNullable(error.message).getOrElse(() => error.code)}');
    }

    return UnexpectedFailure('Erreur inconnue: $error');
  }
}
