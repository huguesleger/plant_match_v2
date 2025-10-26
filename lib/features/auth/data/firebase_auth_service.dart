import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plant_match_v2/features/auth/domain/entities/user_auth.dart';
import 'package:plant_match_v2/features/auth/domain/repository/auth_repository.dart';

class FirebaseAuthService implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<UserAuth?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;

    if (firebaseUser != null) {
      final userDoc = await _firebaseFirestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      if (userDoc.exists) {
        return UserAuth(
          email: firebaseUser.email!,
          uid: firebaseUser.uid,
          fullName: userDoc.data()?['fullName'] ?? '',
        );
      } else {
        return UserAuth(
          email: firebaseUser.email!,
          uid: firebaseUser.uid,
          fullName: '',
        );
      }
    } else {
      return null;
    }
  }

  @override
  Future<UserAuth?> signInWithEmailAndPassword({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        await _firebaseFirestore.collection('users').doc(user.uid).update({
          'isOnline': true,
        });

        return UserAuth(
          uid: user.uid,
          email: user.email!,
          fullName: userDoc.data()?['fullName'] ?? '',
        );
      } else {
        throw Exception(
            'Une erreur inattendue est survenue. Veuillez réessayer.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Aucun compte trouvé pour cet email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Mot de passe incorrect.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Email invalide.');
      } else if (e.code == 'user-disabled') {
        throw Exception('Ce compte a été désactivé.');
      } else if (e.code == 'invalid-credential') {
        throw Exception('Les informations de connexion sont incorrectes.');
      } else {
        throw Exception(
            'Une erreur inattendue est survenue. Veuillez réessayer.');
      }
    } catch (e) {
      throw Exception('Une erreur inconnue est survenue. Veuillez réessayer.');
    }
  }

  @override
  Future<UserAuth?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      // Création du compte Firebase (sans doc Firestore)
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user == null) throw Exception("Impossible de créer l'utilisateur.");

      return UserAuth(
        email: email,
        uid: user.uid,
        fullName: fullName,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> finalizeRegistration(User user, String fullName) async {
    final docRef = _firebaseFirestore.collection('users').doc(user.uid);

    final existingDoc = await docRef.get();
    if (existingDoc.exists) return;

    await docRef.set({
      'email': user.email,
      'fullName': fullName,
      'isOnline': true,
      'createdAt': FieldValue.serverTimestamp(),
      'emailVerified': true,
    });
  }

  @override
  Future<UserAuth?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception("Connexion avec Google annulée.");
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        UserAuth userAuth = UserAuth(
          email: firebaseUser.email,
          uid: firebaseUser.uid,
          fullName: firebaseUser.displayName ?? '',
        );

        await _firebaseFirestore.collection('users').doc(userAuth.uid).set({
          'email': userAuth.email,
          'fullName': userAuth.fullName,
          'isOnline': true,
        });
        return userAuth;
      } else {
        throw Exception("Échec de l'authentification avec Google.");
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<UserAuth?> signInWithFacebook() async {
    try {
      final nonce = DateTime.now().toIso8601String();
      final LoginResult result =
          await FacebookAuth.instance.login(permissions: [
        "public_profile",
        "email",
      ], loginTracking: LoginTracking.enabled, nonce: nonce);

      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        final AccessToken accessToken = result.accessToken!;
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.tokenString);
        await AppTrackingTransparency.requestTrackingAuthorization();

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final User? firebaseUser = userCredential.user;

        if (firebaseUser != null) {
          UserAuth userAuth = UserAuth(
            email: userData['email'],
            uid: firebaseUser.uid,
            fullName: userData['name'],
          );

          await _firebaseFirestore.collection('users').doc(userAuth.uid).set({
            'email': userAuth.email,
            'fullName': userAuth.fullName,
            'isOnline': true,
          });

          return userAuth;
        } else {
          throw Exception('Échec de l\'authentification avec Facebook.');
        }
      } else {
        throw Exception('Connexion avec Facebook annulée.');
      }
    } catch (e) {
      throw Exception('Échec de la connexion avec Facebook.');
    }
  }

  @override
  Future<void> logOut() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await _firebaseFirestore.collection('users').doc(user.uid).update({
          'isOnline': false,
        });
      }
      await _firebaseAuth.signOut();
/*      await _googleSignIn.signOut();
      await FacebookAuth.instance.logOut();*/
    } catch (e) {
      throw Exception("Erreur lors de la déconnexion.");
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Aucun compte trouvé pour cet email.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Email invalide.');
      } else {
        throw Exception(
            'Une erreur inattendue est survenue. Veuillez réessayer.');
      }
    } catch (e) {
      throw Exception('Une erreur inconnue est survenue. Veuillez réessayer.');
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      User? user = _firebaseAuth.currentUser;

      if (user == null) {
        throw Exception(
            "Aucun utilisateur connecté. Impossible d'envoyer le mail de vérification.");
      }
      await user.reload();
      user = _firebaseAuth.currentUser;

      if (user == null) {
        throw Exception("Aucun utilisateur après reload. Réessayez.");
      }

      if (user.emailVerified) {
        throw Exception("Email déjà vérifié.");
      }
      await user.sendEmailVerification();
    } catch (e) {
      throw Exception(
          "Erreur lors de l'envoi de l'email de vérification : ${e.toString()}");
    }
  }

  @override
  Future<bool> isEmailVerified() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.reload();
        return user.emailVerified;
      } else {
        throw Exception("Aucun utilisateur connecté.");
      }
    } catch (e) {
      throw Exception("Erreur lors de la vérification de l'email.");
    }
  }
}
