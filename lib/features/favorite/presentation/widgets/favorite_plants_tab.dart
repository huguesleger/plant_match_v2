import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:plant_match_v2/features/favorite/presentation/widgets/favorite_empty_state.dart';
import 'package:plant_match_v2/features/favorite/presentation/widgets/favorite_plant_card.dart';
import 'package:plant_match_v2/features/user/detail_plant/detail_plant.dart';

class FavoritePlantsTab extends StatelessWidget {
  const FavoritePlantsTab({
    super.key,
    required this.uid,
    required this.plants,
  });

  final String uid;
  final List<Catalog> plants;

  @override
  Widget build(BuildContext context) {
    if (plants.isEmpty) {
      return FavoriteEmptyState(
        icon: Icons.eco_rounded,
        message: t.favorite.empty.plants.title,
        subtitle: t.favorite.empty.plants.subtitle,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      itemCount: plants.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final plant = plants[index];
        final catalogId = plant.catalogId.getOrElse(() => '');
        return FavoritePlantCard(
          plant: plant,
          onRemove: () => context
              .read<FavoriteCubit>()
              .removeFavoritePlant(uid, catalogId),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPlant(catalog: plant),
            ),
          ),
        );
      },
    );
  }
}
