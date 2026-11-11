import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/firebase/cloud_function.dart';
import 'package:plant_match_v2/core/failures/failure_mapper.dart';
import 'package:plant_match_v2/core/util/json_reader.dart';
import 'package:plant_match_v2/features/auth/domain/entities/password_status.dart';
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

  static T _required<T>(Option<T> value, Failure failure) =>
      value.getOrElse(() => throw failure);

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
      (error, _) => _mapAuthError(error),
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
          const UnexpectedFailure('No user after sign in'),
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
      (error, _) => _mapAuthError(error),
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
          const UnexpectedFailure('No user after registration'),
        );
        await user.updateDisplayName('$firstName $lastName'.trim());

        return UserAuth(
          email: Option.fromNullable(email),
          uid: user.uid,
          firstName: firstName,
          lastName: lastName,
        );
      },
      (error, _) => _mapAuthError(error),
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
      (error, _) => _mapAuthError(error),
    );
  }

  @override
  TaskEither<Failure, (UserAuth, bool)> signInWithGoogle() {
    return TaskEither.tryCatch(
      () async {
        final credential = await _googleCredential();

        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = _required(
          Option.fromNullable(userCredential.user),
          const AuthProviderFailure('No user after Google sign in'),
        );

        final userAuth = UserAuth.fromFullName(
          email: Option.fromNullable(firebaseUser.email),
          uid: firebaseUser.uid,
          fullName:
              Option.fromNullable(firebaseUser.displayName).getOrElse(() => ''),
        );

        final docRef = _firebaseFirestore.collection('users').doc(userAuth.uid);
        final docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          await docRef.update({'isOnline': true});
          return (
            _withStoredNames(userAuth, Option.fromNullable(docSnapshot.data())),
            false
          );
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
      (error, _) => _mapAuthError(error),
    );
  }

  @override
  TaskEither<Failure, (UserAuth, bool)> signInWithFacebook() {
    return TaskEither.tryCatch(
      () async {
        final credential = await _facebookCredential();
        final userData = await _facebookAuth.getUserData();
        await AppTrackingTransparency.requestTrackingAuthorization();

        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = _required(
          Option.fromNullable(userCredential.user),
          const AuthProviderFailure('No user after Facebook sign in'),
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
          return (
            _withStoredNames(userAuth, Option.fromNullable(docSnapshot.data())),
            false
          );
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
      (error, _) => _mapAuthError(error),
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
      (error, _) => _mapAuthError(error),
    );
  }

  @override
  TaskEither<Failure, Unit> deleteAccount() =>
      CloudFunction.call('deleteAccount', {})
          .flatMap((_) => _clearLocalSession());

  @override
  TaskEither<Failure, Unit> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      TaskEither.tryCatch(
        () async {
          final user = _required(
            Option.fromNullable(_firebaseAuth.currentUser),
            const SessionExpiredFailure('No current user'),
          );
          final email = _required(
            Option.fromNullable(user.email),
            const SessionExpiredFailure('No email for current user'),
          );
          await user.reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: email,
              password: currentPassword,
            ),
          );
          await user.updatePassword(newPassword);
          return unit;
        },
        (error, _) => _mapAuthError(error),
      ).flatMap((_) => _notifyPasswordChanged());

  TaskEither<Failure, Unit> _notifyPasswordChanged() =>
      CloudFunction.call('notifyPasswordChanged', {})
          .map((_) => unit)
          .orElse((_) => TaskEither.right(unit));

  @override
  PasswordStatus passwordStatus() =>
      Option.fromNullable(_firebaseAuth.currentUser).match(
        () => const PasswordUnavailable(),
        (user) => user.providerData.any(
          (info) => info.providerId == EmailAuthProvider.PROVIDER_ID,
        )
            ? const PasswordSet()
            : Option.fromNullable(user.email)
                .filter((email) => email.isNotEmpty)
                .match<PasswordStatus>(
                  () => const PasswordUnavailable(),
                  PasswordMissing.new,
                ),
      );

  @override
  TaskEither<Failure, Unit> createPassword({required String password}) =>
      TaskEither.tryCatch(
        () async {
          final user = _required(
            Option.fromNullable(_firebaseAuth.currentUser),
            const SessionExpiredFailure('No current user'),
          );
          final email = _required(
            Option.fromNullable(user.email).filter((email) => email.isNotEmpty),
            const AuthNoEmailFailure(),
          );
          final credential = EmailAuthProvider.credential(
            email: email,
            password: password,
          );
          await user.linkWithCredential(credential).catchError(
                (_) => _reauthenticateWithProvider(user)
                    .then((_) => user.linkWithCredential(credential)),
                test: (error) =>
                    error is FirebaseAuthException &&
                    error.code == 'requires-recent-login',
              );
          return unit;
        },
        (error, _) => _mapAuthError(error),
      );

  Future<UserCredential> _reauthenticateWithProvider(User user) async {
    final providerIds =
        user.providerData.map((info) => info.providerId).toSet();
    final credential = providerIds.contains(GoogleAuthProvider.PROVIDER_ID)
        ? await _googleCredential()
        : providerIds.contains(FacebookAuthProvider.PROVIDER_ID)
            ? await _facebookCredential()
            : throw const SessionExpiredFailure(
                'No provider to reauthenticate');
    return user.reauthenticateWithCredential(credential);
  }

  Future<AuthCredential> _googleCredential() async {
    final googleUser = _required(
      Option.fromNullable(await _googleSignIn.signIn()),
      const AuthCancelledFailure('Google sign in cancelled'),
    );
    final googleAuth = await googleUser.authentication;
    return GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
  }

  Future<AuthCredential> _facebookCredential() async {
    final result = await _facebookAuth.login(
      permissions: ['public_profile', 'email'],
      loginTracking: LoginTracking.enabled,
      nonce: DateTime.now().toIso8601String(),
    );
    if (result.status != LoginStatus.success) {
      throw const AuthCancelledFailure('Facebook login cancelled');
    }
    final accessToken = _required(
      Option.fromNullable(result.accessToken),
      const AuthCancelledFailure('Facebook access token missing'),
    );
    return FacebookAuthProvider.credential(accessToken.tokenString);
  }

  TaskEither<Failure, Unit> _clearLocalSession() => TaskEither.tryCatch(
        () async {
          await Future.wait([
            _googleSignIn.signOut().then((_) => unit, onError: (_) => unit),
            _facebookAuth.logOut().then((_) => unit, onError: (_) => unit),
          ]);
          await _firebaseAuth.signOut();
          return unit;
        },
        (error, _) => _mapAuthError(error),
      );

  @override
  TaskEither<Failure, Unit> sendPasswordResetEmail({required String email}) {
    return TaskEither.tryCatch(
      () async {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
        return unit;
      },
      (error, _) => _mapAuthError(error),
    );
  }

  @override
  TaskEither<Failure, Unit> sendEmailVerification() {
    return TaskEither.tryCatch(
      () async {
        await _required(
          Option.fromNullable(_firebaseAuth.currentUser),
          const SessionExpiredFailure('No current user'),
        ).reload();
        final user = _required(
          Option.fromNullable(_firebaseAuth.currentUser),
          const SessionExpiredFailure('No current user after reload'),
        );
        if (user.emailVerified) {
          throw const AuthEmailAlreadyVerifiedFailure();
        }

        await user.sendEmailVerification();
        return unit;
      },
      (error, _) => _mapAuthError(error),
    );
  }

  @override
  TaskEither<Failure, bool> isEmailVerified() {
    return TaskEither.tryCatch(
      () async {
        await _required(
          Option.fromNullable(_firebaseAuth.currentUser),
          const SessionExpiredFailure('No current user'),
        ).reload();
        return Option.fromNullable(_firebaseAuth.currentUser)
            .map((user) => user.emailVerified)
            .getOrElse(() => false);
      },
      (error, _) => _mapAuthError(error),
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

  Failure _mapAuthError(Object error) => switch (error) {
        FirebaseAuthException(:final code) => switch (code) {
            'user-not-found' ||
            'wrong-password' ||
            'invalid-credential' ||
            'invalid-login-credentials' =>
              AuthInvalidCredentialsFailure(code),
            'invalid-email' => AuthInvalidEmailFailure(code),
            'user-disabled' => AuthUserDisabledFailure(code),
            'email-already-in-use' => AuthEmailAlreadyInUseFailure(code),
            'account-exists-with-different-credential' =>
              AuthAccountExistsWithDifferentCredentialFailure(code),
            'weak-password' => AuthWeakPasswordFailure(code),
            'too-many-requests' => AuthTooManyRequestsFailure(code),
            _ => mapError(error),
          },
        Object() => mapError(error),
      };
}
