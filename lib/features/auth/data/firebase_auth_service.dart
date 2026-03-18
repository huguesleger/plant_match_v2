import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/auth/domain/entities/user_auth.dart';
import 'package:plant_match_v2/features/auth/domain/repository/auth_repository.dart';

class FirebaseAuthService implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ─── getCurrentUser ───────────────────────────────────────────────────────

  @override
  TaskEither<Failure, Option<UserAuth>> getCurrentUser() {
    return TaskEither.tryCatch(
      () async {
        final firebaseUser = _firebaseAuth.currentUser;
        if (firebaseUser == null) return const None();

        final userDoc = await _firebaseFirestore
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        return Some(UserAuth(
          email: firebaseUser.email!,
          uid: firebaseUser.uid,
          fullName: userDoc.data()?['fullName'] ?? '',
        ));
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  // ─── signInWithEmailAndPassword ───────────────────────────────────────────

  @override
  TaskEither<Failure, UserAuth> signInWithEmailAndPassword({
    required String email,
    required String password,
    String? fullName,
  }) {
    return TaskEither.tryCatch(
      () async {
        final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        final user = userCredential.user;
        if (user == null) {
          throw const AuthFailure(
              'Une erreur inattendue est survenue. Veuillez réessayer.');
        }

        final userDoc = await _firebaseFirestore
            .collection('users')
            .doc(user.uid)
            .get();

        await _firebaseFirestore
            .collection('users')
            .doc(user.uid)
            .update({'isOnline': true});

        return UserAuth(
          uid: user.uid,
          email: user.email!,
          fullName: userDoc.data()?['fullName'] ?? '',
        );
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  // ─── registerWithEmailAndPassword ─────────────────────────────────────────

  @override
  TaskEither<Failure, UserAuth> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) {
    return TaskEither.tryCatch(
      () async {
        final userCredential = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);

        final user = userCredential.user;
        if (user == null) {
          throw const AuthFailure("Impossible de créer l'utilisateur.");
        }

        return UserAuth(email: email, uid: user.uid, fullName: fullName);
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  // ─── finalizeRegistration ─────────────────────────────────────────────────

  @override
  TaskEither<Failure, bool> finalizeRegistration(
      User user, String fullName) {
    return TaskEither.tryCatch(
      () async {
        final docRef =
            _firebaseFirestore.collection('users').doc(user.uid);
        final existingDoc = await docRef.get();
        if (existingDoc.exists) return false;

        await docRef.set({
          'email': user.email,
          'fullName': fullName,
          'isOnline': true,
          'createdAt': FieldValue.serverTimestamp(),
          'emailVerified': true,
        });
        return true;
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  // ─── signInWithGoogle ─────────────────────────────────────────────────────

  @override
  TaskEither<Failure, UserAuth> signInWithGoogle() {
    return TaskEither.tryCatch(
      () async {
        final googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          throw const AuthFailure('Connexion avec Google annulée.');
        }

        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = userCredential.user;

        if (firebaseUser == null) {
          throw const AuthFailure("Échec de l'authentification avec Google.");
        }

        final userAuth = UserAuth(
          email: firebaseUser.email,
          uid: firebaseUser.uid,
          fullName: firebaseUser.displayName ?? '',
        );

        await _firebaseFirestore
            .collection('users')
            .doc(userAuth.uid)
            .set({
          'email': userAuth.email,
          'fullName': userAuth.fullName,
          'isOnline': true,
        });

        return userAuth;
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  // ─── signInWithFacebook ───────────────────────────────────────────────────

  @override
  TaskEither<Failure, UserAuth> signInWithFacebook() {
    return TaskEither.tryCatch(
      () async {
        final nonce = DateTime.now().toIso8601String();
        final result = await FacebookAuth.instance.login(
          permissions: ['public_profile', 'email'],
          loginTracking: LoginTracking.enabled,
          nonce: nonce,
        );

        if (result.status != LoginStatus.success) {
          throw const AuthFailure('Connexion avec Facebook annulée.');
        }

        final userData = await FacebookAuth.instance.getUserData();
        final accessToken = result.accessToken!;
        final credential =
            FacebookAuthProvider.credential(accessToken.tokenString);
        await AppTrackingTransparency.requestTrackingAuthorization();

        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final firebaseUser = userCredential.user;

        if (firebaseUser == null) {
          throw const AuthFailure(
              "Échec de l'authentification avec Facebook.");
        }

        final userAuth = UserAuth(
          email: userData['email'],
          uid: firebaseUser.uid,
          fullName: userData['name'],
        );

        await _firebaseFirestore
            .collection('users')
            .doc(userAuth.uid)
            .set({
          'email': userAuth.email,
          'fullName': userAuth.fullName,
          'isOnline': true,
        });

        return userAuth;
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  // ─── logOut ───────────────────────────────────────────────────────────────

  @override
  TaskEither<Failure, Unit> logOut() {
    return TaskEither.tryCatch(
      () async {
        try {
          await _googleSignIn.signOut();
        } catch (_) {}

        try {
          await FacebookAuth.instance.logOut();
        } catch (_) {}

        try {
          final user = _firebaseAuth.currentUser;
          if (user != null) {
            await _firebaseFirestore
                .collection('users')
                .doc(user.uid)
                .update({'isOnline': false});
          }
        } catch (e) {
          debugPrint(
              'Note: Impossible de mettre à jour le statut online: $e');
        }

        await _firebaseAuth.signOut();
        return unit;
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  // ─── sendPasswordResetEmail ───────────────────────────────────────────────

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

  // ─── sendEmailVerification ────────────────────────────────────────────────

  @override
  TaskEither<Failure, Unit> sendEmailVerification() {
    return TaskEither.tryCatch(
      () async {
        User? user = _firebaseAuth.currentUser;
        if (user == null) {
          throw const AuthFailure(
              "Aucun utilisateur connecté. Impossible d'envoyer le mail de vérification.");
        }

        await user.reload();
        user = _firebaseAuth.currentUser;

        if (user == null) {
          throw const AuthFailure('Aucun utilisateur après reload. Réessayez.');
        }
        if (user.emailVerified) {
          throw const AuthFailure('Email déjà vérifié.');
        }

        await user.sendEmailVerification();
        return unit;
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  // ─── isEmailVerified ──────────────────────────────────────────────────────

  @override
  TaskEither<Failure, bool> isEmailVerified() {
    return TaskEither.tryCatch(
      () async {
        final user = _firebaseAuth.currentUser;
        if (user == null) {
          throw const AuthFailure('Aucun utilisateur connecté.');
        }
        await user.reload();
        return _firebaseAuth.currentUser?.emailVerified ?? false;
      },
      (error, _) => _mapErrorToFailure(error),
    );
  }

  // ─── Mapping d'erreurs ────────────────────────────────────────────────────

  Failure _mapErrorToFailure(Object error) {
    if (error is Failure) return error;

    if (error is FirebaseAuthException) {
      final message = switch (error.code) {
        'user-not-found' => 'Aucun compte trouvé pour cet email.',
        'wrong-password' => 'Mot de passe incorrect.',
        'invalid-email' => 'Email invalide.',
        'user-disabled' => 'Ce compte a été désactivé.',
        'invalid-credential' =>
          'Les informations de connexion sont incorrectes.',
        _ => 'Une erreur inattendue est survenue. Veuillez réessayer.',
      };
      return AuthFailure(message);
    }

    if (error is FirebaseException) {
      return FirebaseFailure('Erreur Firebase: ${error.message ?? error.code}');
    }

    return UnexpectedFailure('Erreur inconnue: $error');
  }
}
