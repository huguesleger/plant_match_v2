import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/recommendation/presentation/cubit/recommendation_cubit.dart';
import 'package:plant_match_v2/features/recommendation/presentation/widgets/recommendation_card_item.dart';

class RecommendationResultView extends StatelessWidget {
  const RecommendationResultView({super.key, required this.plants});

  final List<Catalog> plants;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: plants.isEmpty
          ? const _EmptyResultsView()
          : _ResultsListView(plants: plants),
    );
  }
}

class _EmptyResultsView extends StatelessWidget {
  const _EmptyResultsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingHorizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.res.images.emptyCatalogFilter.image(height: 200),
            const SizedBox(height: 24),
            const Text(
              "Aucune plante ne correspond à tes critères.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Essaie d'ajuster tes critères en élargissant tes choix.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.greyDark),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.read<RecommendationCubit>().reset(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenDark,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text("Recommencer le questionnaire"),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultsListView extends StatelessWidget {
  const _ResultsListView({required this.plants});

  final List<Catalog> plants;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            plants.length == 1
                ? "Nous avons trouvé 1 plante idéale pour toi !"
                : "Nous avons trouvé ${plants.length} plantes idéales pour toi !",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: plants.length,
            itemBuilder: (context, index) {
              return RecommendationCardItem(catalog: plants[index]);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.read<RecommendationCubit>().reset(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.greenDark),
                foregroundColor: AppColors.greenDark,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text("Refaire le test"),
            ),
          ),
        ),
      ],
    );
  }
}
