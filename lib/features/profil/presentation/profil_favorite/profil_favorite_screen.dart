import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_favorite/cubit/profil_favorite_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_favorite/widgets/favorite_plant_card.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_favorite/widgets/favorite_user_card.dart';

class ProfilFavoriteScreen extends StatelessWidget {
  const ProfilFavoriteScreen({
    super.key,
    required this.uid,
    required this.plants,
    required this.users,
  });

  final String uid;
  final List<Map<String, dynamic>> plants;
  final List<ProfilUser> users;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // TabBar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.greyUltraLight,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TabBar(
              indicator: BoxDecoration(
                color: AppColors.greenMedium,
                borderRadius: BorderRadius.circular(30),
              ),
              indicatorPadding: const EdgeInsets.all(4),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: AppColors.white,
              unselectedLabelColor: AppColors.greyMedium,
              labelStyle: InterTextStyle.inter(
                AppTypo.textS,
                fontWeight: FontWeight.w600,
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.eco_rounded, size: 16),
                      const SizedBox(width: 6),
                      Text('Plantes (${plants.length})'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person_rounded, size: 16),
                      const SizedBox(width: 6),
                      Text('Profils (${users.length})'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Contenu
          Expanded(
            child: TabBarView(
              children: [
                _PlantsTab(uid: uid, plants: plants),
                _UsersTab(uid: uid, users: users),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ─── Onglet Plantes ──────────────────────────────────────────────────────────

class _PlantsTab extends StatelessWidget {
  const _PlantsTab({required this.uid, required this.plants});

  final String uid;
  final List<Map<String, dynamic>> plants;

  @override
  Widget build(BuildContext context) {
    if (plants.isEmpty) {
      return _EmptyState(
        icon: Icons.eco_rounded,
        message: 'Aucune plante en favoris',
        subtitle: 'Appuyez sur ❤️ sur une plante pour l\'ajouter',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      itemCount: plants.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final plant = plants[index];
        final catalogId = plant['id'] as String? ?? '';
        return FavoritePlantCard(
          plant: plant,
          onRemove: () => context
              .read<ProfilFavoriteCubit>()
              .removeFavoritePlant(uid, catalogId),
          onTap: () {
            // Navigation vers détail si disponible — à brancher selon contexte
          },
        );
      },
    );
  }
}

/// ─── Onglet Profils ──────────────────────────────────────────────────────────

class _UsersTab extends StatelessWidget {
  const _UsersTab({required this.uid, required this.users});

  final String uid;
  final List<ProfilUser> users;

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return _EmptyState(
        icon: Icons.person_search_rounded,
        message: 'Aucun profil en favoris',
        subtitle: 'Appuyez sur ❤️ sur un profil pour l\'ajouter',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      itemCount: users.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final user = users[index];
        return FavoriteUserCard(
          user: user,
          onRemove: () => context
              .read<ProfilFavoriteCubit>()
              .removeFavoriteUser(uid, user.uid),
          onTap: () {
            // Navigation vers profil — à brancher selon contexte
          },
        );
      },
    );
  }
}

/// ─── Empty state ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.message,
    required this.subtitle,
  });

  final IconData icon;
  final String message;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.greenMedium.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.greenMedium, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: InterTextStyle.inter(
                AppTypo.textM,
                fontWeight: FontWeight.w700,
                color: AppColors.greyDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: InterTextStyle.inter(
                AppTypo.textXs,
                color: AppColors.greyMedium,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
