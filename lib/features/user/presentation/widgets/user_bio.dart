import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:fpdart/fpdart.dart';

class UserBio extends StatelessWidget {
  const UserBio({
    super.key,
    required this.bio,
  });

  final String? bio;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingHorizontal,
        child: Text(
          Option.fromNullable(bio)
              .filter((b) => b.isNotEmpty)
              .getOrElse(() => 'Pas encore de description...'),
          style: const TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
