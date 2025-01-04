import 'package:plant_match_v2/presentation/auth/domain/entities/user_auth.dart';

abstract class AuthRepository {
  Future<UserAuth?> signInWithEmailAndPassword(
      {required String email, required String password});

  Future<UserAuth?> registerWithEmailAndPassword(
      {required String email,
      required String password,
      required String fullName});

  Future<UserAuth?> getCurrentUser();

  Future<UserAuth?> signInWithGoogle();

  Future<UserAuth?> signInWithFacebook();

  Future<void> logOut();
}
