import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/favorite/presentation/widgets/favorite_plants_tab.dart';
import 'package:plant_match_v2/features/favorite/presentation/widgets/favorite_users_tab.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class FavoriteTabs extends StatelessWidget {
  const FavoriteTabs({
    super.key,
    required this.uid,
    required this.plants,
    required this.users,
  });

  final String uid;
  final List<Catalog> plants;
  final List<ProfilUser> users;

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: TabBar.secondary(
                tabs: [
                  _FavoriteTab(
                    icon: Icons.eco_rounded,
                    label: t.favorite.screen.plants_tab(count: plants.length),
                  ),
                  _FavoriteTab(
                    icon: Icons.person_rounded,
                    label: t.favorite.screen.users_tab(count: users.length),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  FavoritePlantsTab(uid: uid, plants: plants),
                  FavoriteUsersTab(uid: uid, users: users),
                ],
              ),
            ),
          ],
        ),
      );
}

class _FavoriteTab extends StatelessWidget {
  const _FavoriteTab({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
      );
}
