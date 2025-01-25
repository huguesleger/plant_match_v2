import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/presentation/user_points/domain/repository/user_points_repository.dart';
import 'package:plant_match_v2/presentation/user_points/presentation/cubit/user_points_state.dart';

class UserPointsCubit extends Cubit<UserPointsState> {
  final UserPointsRepository repository;

  UserPointsCubit({required this.repository}) : super(UserPointsInitial());

  Future<void> fetchUserPoints(String userId) async {
    emit(UserPointsLoading());
    try {
      final userPoints = await repository.getPoints(userId);
      emit(UserPointsLoaded(
          userPoints.currentPoints, userPoints.level, userPoints));
    } catch (e) {
      emit(UserPointsError('Erreur: $e'));
    }
  }

  Future<void> addUserPoints(
      String userId, int initialPoints, int level) async {
    emit(UserPointsLoading());
    try {
      final userPoints =
          await repository.addPoints(userId, initialPoints, level);
      emit(UserPointsLoaded(
          userPoints.currentPoints, userPoints.level, userPoints));
    } catch (e) {
      emit(UserPointsError('Erreur: $e'));
    }
  }

  Future<void> updateUserPoints(String userId, int pointsToAdd) async {
    emit(UserPointsLoading());
    try {
      await repository.updatePoints(userId, pointsToAdd);
      await fetchUserPoints(userId);
    } catch (e) {
      emit(UserPointsError('Erreur: $e'));
    }
  }
}
