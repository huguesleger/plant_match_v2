import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/level/domain/entities/user_points.dart';
import 'package:plant_match_v2/features/level/utils/user_points_utils.dart';

void main() {
  group('levelForPoints', () {
    test('maps transaction counts to the 7 thresholds', () {
      final expected = {
        0: 1,
        1: 1,
        2: 2,
        4: 2,
        5: 3,
        10: 4,
        25: 5,
        49: 5,
        50: 6,
        100: 7,
        250: 7,
      };
      expected.forEach(
        (points, level) =>
            expect(UserPointsUtils.levelForPoints(points), level),
      );
    });
  });

  group('bonusLeavesBetween', () {
    test('awards the bonus of the reached level', () {
      expect(UserPointsUtils.bonusLeavesBetween(1, 2), 3);
      expect(UserPointsUtils.bonusLeavesBetween(5, 6), 20);
    });

    test('sums bonuses when several levels are skipped', () {
      expect(UserPointsUtils.bonusLeavesBetween(1, 4), 3 + 5 + 8);
    });

    test('gives nothing without level up or for level 7', () {
      expect(UserPointsUtils.bonusLeavesBetween(3, 3), 0);
      expect(UserPointsUtils.bonusLeavesBetween(6, 7), 0);
    });
  });

  test('only level 7 has unlimited contacts', () {
    expect(UserPointsUtils.hasUnlimitedContacts(6), isFalse);
    expect(UserPointsUtils.hasUnlimitedContacts(7), isTrue);
  });

  test('getNextLevel stops after level 7', () {
    expect(UserPointsUtils.getNextLevel(6), const Some(7));
    expect(UserPointsUtils.getNextLevel(7), const None());
  });

  test('updatePoints never goes below zero and recomputes level', () {
    const start = UserPoints(uid: 'u', currentPoints: 4, level: 2);
    expect(UserPointsUtils.updatePoints(start, 1).level, 3);
    expect(UserPointsUtils.updatePoints(start, -10).currentPoints, 0);
  });

  test('progression is computed inside the current level', () {
    const user = UserPoints(uid: 'u', currentPoints: 7, level: 3);
    expect(UserPointsUtils.calculateLevelProgression(user), closeTo(0.4, 1e-9));
    const top = UserPoints(uid: 'u', currentPoints: 120, level: 7);
    expect(UserPointsUtils.calculateLevelProgression(top), 1.0);
  });

  group('progressionFor', () {
    test('starts at zero on the threshold of the level', () {
      expect(UserPointsUtils.progressionFor(2, 2), 0.0);
      expect(UserPointsUtils.progressionFor(0, 1), 0.0);
    });

    test('is relative to the current level range', () {
      expect(UserPointsUtils.progressionFor(1, 1), closeTo(0.5, 1e-9));
      expect(UserPointsUtils.progressionFor(75, 6), closeTo(0.5, 1e-9));
    });

    test('is full at max level', () {
      expect(UserPointsUtils.progressionFor(100, 7), 1.0);
    });
  });

  test('requiredPointsFor matches level thresholds', () {
    expect(
      List.generate(7, (index) => UserPointsUtils.requiredPointsFor(index + 1)),
      [0, 2, 5, 10, 25, 50, 100],
    );
  });
}
