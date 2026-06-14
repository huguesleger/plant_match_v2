import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_state.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/recent_activity/recent_activity_tile.dart';

class RecentActivityScreen extends StatelessWidget {
  const RecentActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthCubit>().userId ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F9),
      appBar: AppBar(
        title: const Text("Activité récente", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.black)),
        backgroundColor: const Color(0xFFF8F8F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevron_left, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<AroundMeCubit, AroundMeState>(
          builder: (context, state) => switch (state) {
            AroundMeInitial() || AroundMeLoading() => const Center(child: CircularProgressIndicator()),
            AroundMeError(:final message) => ErrorPage(
                errorMessage: message,
                onRetry: () => context.read<AroundMeCubit>().getAllUserProfiles(uid),
              ),
            AroundMeLoaded(:final users, :final currentUser, :final userCatalogs) => _buildList(context, users, currentUser, userCatalogs),
          },
        ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    List<ProfilUser> users,
    ProfilUser currentUser,
    Map<String, List<Catalog>> userCatalogs,
  ) {
    final activities = <(Catalog, ProfilUser)>[];
    userCatalogs.forEach((uid, catalogs) {
      if (uid == currentUser.uid) return;
      final owner = users.firstWhere((u) => u.uid == uid, orElse: () => currentUser);
      if (owner.uid == currentUser.uid) return;
      for (final cat in catalogs) {
        if (cat.status == CatalogStatus.published) activities.add((cat, owner));
      }
    });
    activities.sort((a, b) => b.$1.createdAt.compareTo(a.$1.createdAt));

    return activities.isEmpty
        ? const Center(child: Text("Aucune activité récente", style: TextStyle(color: AppColors.greyMedium)))
        : ListView.separated(
            padding: AppSpacing.paddingAll,
            itemCount: activities.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final (catalog, owner) = activities[index];
              return RecentActivityTile(
                catalog: catalog,
                owner: owner,
                currentUserId: currentUser.uid,
              );
            },
          );
  }
}
