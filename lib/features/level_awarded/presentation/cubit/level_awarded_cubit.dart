import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/level/domain/repository/user_points_repository.dart';
import 'package:plant_match_v2/features/level_awarded/presentation/cubit/level_awarded_state.dart';

class LevelAwardedCubit extends Cubit<LevelAwardedState> {
  LevelAwardedCubit({
    required this.userPointsRepository,
  }) : super(LevelAwardedInitial());

  final UserPointsRepository userPointsRepository;

  void load(String userId) {
    emit(LevelAwardedLoading());
    userPointsRepository
        .getPoints(userId)
        .match(
          (failure) => LevelAwardedError(failure.message),
          (userPoints) => LevelAwardedLoaded(userPoints),
        )
        .map(emit)
        .run();
  }
}
