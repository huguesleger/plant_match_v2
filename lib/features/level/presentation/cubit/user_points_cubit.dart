import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/level/domain/entities/points_update.dart';
import 'package:plant_match_v2/features/level/domain/entities/user_points.dart';
import 'package:plant_match_v2/features/level/domain/repository/user_points_repository.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_state.dart';
import 'package:plant_match_v2/features/level/utils/user_points_utils.dart';

class UserPointsCubit extends Cubit<UserPointsState> {
  final UserPointsRepository repository;

  Option<UserPoints> _known = const None();
  Option<StreamSubscription<Either<Failure, UserPoints>>> _subscription =
      const None();
  int _pendingUpdates = 0;
  int _session = 0;

  UserPointsCubit({required this.repository}) : super(UserPointsInitial());

  Option<UserPoints> get lastKnownPoints => _known;

  int get currentLevel =>
      _known.map((points) => points.level).getOrElse(() => 1);

  void fetchUserPoints(String userId) {
    _cancelSubscription();
    _known = _known.filter((points) => points.uid == userId);
    _safeEmit(
      _known.match(() => UserPointsLoading(), _loaded),
    );
    _watch(userId);
  }

  void addUserPoints(String userId, int initialPoints, int level) {
    _cancelSubscription();
    _safeEmit(UserPointsLoading());

    repository
        .addPoints(userId, initialPoints, level)
        .match(
          _fallback,
          (userPoints) => _remember(userPoints, _loaded(userPoints)),
        )
        .map(_safeEmit)
        .map((_) => _watch(userId))
        .run();
  }

  Future<Either<Failure, PointsUpdate>> track(
    TaskEither<Failure, PointsUpdate> update,
  ) async {
    final session = _session;
    _pendingUpdates++;
    final result = await update.run();
    if (session != _session) return result;
    _pendingUpdates--;
    result.match(
      (_) => null,
      (points) => _safeEmit(
        _remember(points.userPoints, UserPointsAwarded(points)),
      ),
    );
    return result;
  }

  void reset() {
    _session++;
    _cancelSubscription();
    _known = const None();
    _pendingUpdates = 0;
    _safeEmit(UserPointsInitial());
  }

  @override
  Future<void> close() {
    _cancelSubscription();
    return super.close();
  }

  void _watch(String userId) {
    _cancelSubscription();
    _subscription = Some(
      repository.watchPoints(userId).listen(
            (result) => _safeEmit(result.match(_fallback, _onSnapshot)),
          ),
    );
  }

  UserPointsState _onSnapshot(UserPoints userPoints) {
    final remoteLevelUp = _known.map((previous) => previous.level).filter(
        (previousLevel) =>
            _pendingUpdates == 0 && userPoints.level > previousLevel);
    return _remember(
      userPoints,
      remoteLevelUp.match(
        () => _loaded(userPoints),
        (previousLevel) => UserPointsAwarded(
          PointsUpdate(
            userPoints: userPoints,
            previousLevel: previousLevel,
            bonusLeaves: UserPointsUtils.bonusLeavesBetween(
              previousLevel,
              userPoints.level,
            ),
            giftedLeaves: 0,
          ),
        ),
      ),
    );
  }

  UserPointsState _fallback(Failure failure) =>
      _known.match(() => UserPointsError(failure.message), _loaded);

  UserPointsState _remember(UserPoints userPoints, UserPointsState state) {
    _known = Some(userPoints);
    return state;
  }

  UserPointsState _loaded(UserPoints userPoints) => UserPointsLoaded(
        userPoints.currentPoints,
        userPoints.level,
        userPoints,
      );

  void _cancelSubscription() {
    _subscription.map((subscription) => subscription.cancel());
    _subscription = const None();
  }

  void _safeEmit(UserPointsState state) {
    if (!isClosed) emit(state);
  }
}
