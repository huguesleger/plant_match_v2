import 'package:flutter/material.dart';
import 'package:plant_match_v2/features/level_awarded/presentation/level_awarded_screen.dart';

class LevelAwardedPageRoute extends StatelessWidget {
  const LevelAwardedPageRoute({
    super.key,
    required this.leavesGained,
    required this.title,
    required this.description,
  });

  final int leavesGained;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return LevelAwardedScreen(
      leavesGained: leavesGained,
      title: title,
      description: description,
    );
  }
}
