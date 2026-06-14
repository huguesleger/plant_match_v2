import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/recent_activity/recent_activity_tile.dart';

class HomeRecentActivity extends StatelessWidget {
  const HomeRecentActivity({
    super.key,
    required this.activities,
    required this.onSeeAllPressed,
  });

  final List<(Catalog, ProfilUser)> activities;
  final VoidCallback onSeeAllPressed;

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<AuthCubit>().userId ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Activité récente",
              style: TextStyle(fontSize: AppTypo.textM, fontWeight: FontWeight.bold, color: AppColors.black),
            ),
            TextButton(
              onPressed: onSeeAllPressed,
              child: const Row(
                children: [
                  Text("Voir tout", style: TextStyle(color: AppColors.greyMedium, fontSize: AppTypo.textXs)),
                  SizedBox(width: 2),
                  Icon(LucideIcons.chevron_right, color: AppColors.greyMedium, size: 12),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        activities.isEmpty
            ? const Text("Aucune activité récente", style: TextStyle(color: AppColors.greyMedium, fontSize: AppTypo.textS))
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activities.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final (catalog, owner) = activities[index];
                  return RecentActivityTile(
                    catalog: catalog,
                    owner: owner,
                    currentUserId: currentUserId,
                  );
                },
              ),
      ],
    );
  }
}
