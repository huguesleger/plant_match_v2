import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/level/utils/user_points_utils.dart';

class LevelDetail {
  final String condition;
  final String description;
  final int requiredTransactions;
  final String reward;

  const LevelDetail({
    required this.condition,
    required this.description,
    required this.requiredTransactions,
    required this.reward,
  });
}

class UserLevelDetails {
  static (String, String) _texts(int level) => Option.fromNullable({
        1: (t.level.levels.k1.condition, t.level.levels.k1.description),
        2: (t.level.levels.k2.condition, t.level.levels.k2.description),
        3: (t.level.levels.k3.condition, t.level.levels.k3.description),
        4: (t.level.levels.k4.condition, t.level.levels.k4.description),
        5: (t.level.levels.k5.condition, t.level.levels.k5.description),
        6: (t.level.levels.k6.condition, t.level.levels.k6.description),
        7: (t.level.levels.k7.condition, t.level.levels.k7.description),
      }[level])
          .getOrElse(
        () => (
          t.level.levels.unknown.condition,
          t.level.levels.unknown.description
        ),
      );

  static String _reward(int level) => level == 1
      ? t.level.detail.welcome_pack
      : level == UserPointsUtils.maxLevel
          ? t.level.detail.unlimited_contacts
          : t.level.detail.bonus_leaves(
              n: UserPointsUtils.getBonusLeavesForLevel(level),
            );

  static LevelDetail getLevelDetails(int level) {
    final (condition, description) = _texts(level);
    return LevelDetail(
      condition: condition,
      description: description,
      requiredTransactions: UserPointsUtils.requiredPointsFor(level),
      reward: _reward(level),
    );
  }
}
