import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/level/domain/entities/points_update.dart';
import 'package:plant_match_v2/features/level/domain/entities/user_points.dart';
import 'package:plant_match_v2/features/level/domain/repository/user_points_repository.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_cubit.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_state.dart';

class _FakeRepository implements UserPointsRepository {
  final controller = StreamController<Either<Failure, UserPoints>>.broadcast();
  Either<Failure, PointsUpdate> nextUpdate =
      const Left(FirebaseFailure('offline'));
  final updateGate = Completer<Unit>();

  @override
  TaskEither<Failure, UserPoints> addPoints(
    String userId,
    int initialPoints,
    int level,
  ) =>
      TaskEither.right(
        UserPoints(uid: userId, currentPoints: initialPoints, level: level),
      );

  @override
  TaskEither<Failure, UserPoints> getPoints(String userId) =>
      TaskEither.left(const NotFoundFailure('unused'));

  TaskEither<Failure, PointsUpdate> pendingUpdate() =>
      TaskEither(() => updateGate.future.then((_) => nextUpdate));

  @override
  Stream<Either<Failure, UserPoints>> watchPoints(String userId) =>
      controller.stream;
}

const _uid = 'u';

UserPoints _points(int points, int level) =>
    UserPoints(uid: _uid, currentPoints: points, level: level);

Future<Unit> _flush() => Future<Unit>.delayed(Duration.zero, () => unit);

void main() {
  late _FakeRepository repository;
  late UserPointsCubit cubit;
  late List<UserPointsState> states;

  setUp(() {
    repository = _FakeRepository();
    cubit = UserPointsCubit(repository: repository);
    states = [];
    cubit.stream.listen(states.add);
  });

  tearDown(() => cubit.close());

  List<UserPointsAwarded> awarded() =>
      states.whereType<UserPointsAwarded>().toList();

  test('keeps the last known level when an update fails', () async {
    cubit.fetchUserPoints(_uid);
    repository.controller.add(Right(_points(120, 7)));
    await _flush();

    cubit.track(repository.pendingUpdate());
    repository.updateGate.complete(unit);
    await _flush();

    expect(cubit.currentLevel, 7);
    expect(cubit.state, isA<UserPointsLoaded>());
  });

  test('emits a level up when the snapshot level increases remotely', () async {
    cubit.fetchUserPoints(_uid);
    repository.controller.add(Right(_points(1, 1)));
    await _flush();
    repository.controller.add(Right(_points(2, 2)));
    await _flush();

    expect(awarded().single.update.isLevelUp, isTrue);
    expect(awarded().single.update.bonusLeaves, 3);
    expect(cubit.currentLevel, 2);
  });

  test('does not celebrate twice for the user who validated', () async {
    cubit.fetchUserPoints(_uid);
    repository.controller.add(Right(_points(1, 1)));
    await _flush();

    repository.nextUpdate = Right(
      PointsUpdate(
        userPoints: _points(2, 2),
        previousLevel: 1,
        bonusLeaves: 3,
        giftedLeaves: 0,
      ),
    );
    cubit.track(repository.pendingUpdate());
    repository.controller.add(Right(_points(2, 2)));
    await _flush();
    repository.updateGate.complete(unit);
    await _flush();
    repository.controller.add(Right(_points(2, 2)));
    await _flush();

    expect(awarded().length, 1);
  });

  test('reset forgets the user', () async {
    cubit.fetchUserPoints(_uid);
    repository.controller.add(Right(_points(120, 7)));
    await _flush();

    cubit.reset();
    await _flush();

    expect(cubit.state, isA<UserPointsInitial>());
    expect(cubit.currentLevel, 1);
  });
}
