import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/favorite/cubit/favorite_cubit.dart';
import 'package:plant_match_v2/features/favorite/widgets/favorite_empty_state.dart';
import 'package:plant_match_v2/features/favorite/widgets/favorite_user_card.dart';

class FavoriteUsersTab extends StatelessWidget {
  const FavoriteUsersTab({
    super.key,
    required this.uid,
    required this.users,
  });

  final String uid;
  final List<ProfilUser> users;

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const FavoriteEmptyState(
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
              .read<FavoriteCubit>()
              .removeFavoriteUser(uid, user.uid),
          onTap: () {},
        );
      },
    );
  }
}
