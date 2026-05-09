import 'package:plant_match_v2/core/i18n/translations.g.dart';

class UserLevelDetails {
  static Map<int, Map<String, dynamic>> get levelDetails => {
        1: {
          "condition": t.level.levels.k1.condition,
          "description": t.level.levels.k1.description,
          "requiredPoints": 50,
          "rewardedActions": {
            t.level.levels.k1.actions.registration: 25,
            t.level.levels.k1.actions.first_plant: 25,
          },
        },
        2: {
          "condition": t.level.levels.k2.condition,
          "description": t.level.levels.k2.description,
          "requiredPoints": 150,
          "rewardedActions": {
            t.level.levels.k2.actions.first_exchange: 50,
            t.level.levels.k2.actions.extra_exchange: 25,
          },
        },
      };

  static Map<String, dynamic> getLevelDetails(int level) {
    return levelDetails[level] ??
        {
          "condition": t.level.levels.unknown.condition,
          "description": t.level.levels.unknown.description,
          "requiredPoints": 0,
          "rewardedActions": {},
        };
  }
}
