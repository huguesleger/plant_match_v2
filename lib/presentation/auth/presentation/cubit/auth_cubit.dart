import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/presentation/auth/domain/entities/user_auth.dart';
import 'package:plant_match_v2/presentation/auth/domain/repository/auth_repository.dart';
import 'package:plant_match_v2/presentation/auth/presentation/cubit/auth_state.dart';
import 'package:plant_match_v2/presentation/user_points/data/firebase_user_points.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  UserAuth? _currentUser;

  //final UserPointsCubit userPointsCubit;
  //final UserPointsRepository userPointsRepository;
  final FirebaseUserPoints userPointsRepository;

  AuthCubit({required this.authRepository, required this.userPointsRepository})
      : super(AuthInitial());

  UserAuth? get currentUser => _currentUser;

  void checkCurrentUser() async {
    final UserAuth? user = await authRepository.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

/*  void checkCurrentUser() async {
    try {
      final UserAuth? user = await authRepository.getCurrentUser();

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      print("Erreur lors de la récupération de l'utilisateur : $e");
      emit(AuthError(errorMessage));
    }
  }*/

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      final UserAuth? user = await authRepository.signInWithEmailAndPassword(
          email: email, password: password);
      _currentUser = user;
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(AuthError(errorMessage));
      emit(Unauthenticated());
    }
  }

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      emit(AuthLoading());
      final UserAuth? user = await authRepository.registerWithEmailAndPassword(
        email: email,
        password: password,
        fullName: fullName,
      );
      if (user != null) {
        _currentUser = user;
        await _addInitialPoints(user.uid);
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(AuthError(errorMessage));
      emit(Unauthenticated());
    }
  }

  Future<void> _addInitialPoints(String userId) async {
    try {
      const int initialPoints = 25;
      const int initialLevel = 1;

      await FirebaseFirestore.instance
          .collection('userPoints')
          .doc(userId)
          .set({
        'currentPoints': initialPoints,
        'level': initialLevel,
      });
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout des points initiaux : $e');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(AuthLoading());
      final UserAuth? user = await authRepository.signInWithGoogle();
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(AuthError(errorMessage));
      emit(Unauthenticated());
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      emit(AuthLoading());
      final UserAuth? user = await authRepository.signInWithFacebook();
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(AuthError(errorMessage));
      emit(Unauthenticated());
    }
  }

  Future<void> logOut() async {
    authRepository.logOut();
    emit(Unauthenticated());
  }
}
