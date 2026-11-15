import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/widgets/template/template_page.dart';
import 'package:plant_match_v2/features/level/presentation/level_page_route.dart';
import 'package:plant_match_v2/features/level_awarded/presentation/level_awarded_exit.dart';
import 'package:plant_match_v2/features/level_awarded/presentation/level_awarded_page_route.dart';

Future<Unit> showLevelAwarded(
  NavigatorState navigator, {
  required int leaves,
  required String title,
  required String description,
}) =>
    navigator
        .push<LevelAwardedExit>(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => LevelAwardedPageRoute(
              leavesGained: leaves,
              title: title,
              description: description,
            ),
          ),
        )
        .then(
          (exit) => switch (Option.fromNullable(exit)
              .getOrElse(() => const LevelAwardedClosed())) {
            LevelAwardedClosed() => unit,
            LevelAwardedViewProgression() => _openProgression(navigator),
          },
        );

Unit _openProgression(NavigatorState navigator) {
  navigator.popUntil((route) => route.isFirst);
  Option.fromNullable(templatePageKey.currentState)
      .map((template) => template.onPageChanged(profilPageIndex));
  navigator.push(MaterialPageRoute(builder: (_) => LevelPageRoute()));
  return unit;
}
