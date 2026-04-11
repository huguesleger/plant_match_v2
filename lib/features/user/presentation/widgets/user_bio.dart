import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';

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
          (bio == null || bio!.isEmpty) ? 'Pas encore de description...' : bio!,
          style: const TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
