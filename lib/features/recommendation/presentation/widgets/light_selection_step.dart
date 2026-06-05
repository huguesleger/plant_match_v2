import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/recommendation/domain/entities/recommendation_answers.dart';
import 'package:plant_match_v2/features/recommendation/presentation/cubit/recommendation_cubit.dart';

class LightSelectionStep extends StatelessWidget {
  final RecommendationAnswers answers;

  const LightSelectionStep({
    super.key,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RecommendationCubit>();
    final selectedLight = answers.light.toNullable();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quelle est l'exposition ?",
          style: TextStyle(
            fontSize: 20,
            fontWeight: bold,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "La luminosité est essentielle pour le bon développement de la plante.",
          style: TextStyle(fontSize: 14, color: AppColors.greyDark),
        ),
        const SizedBox(height: 24),
        _buildOptionCard(
          context,
          title: "Ombragée / Sombre",
          subtitle: "Peu de fenêtres, pièces fraîches",
          icon: LucideIcons.cloud,
          isSelected: selectedLight is LowLight,
          onTap: () => cubit.selectLight(LowLight()),
        ),
        const SizedBox(height: 16),
        _buildOptionCard(
          context,
          title: "Lumière indirecte",
          subtitle: "Lumineux sans soleil direct sur les feuilles",
          icon: LucideIcons.sun_dim,
          isSelected: selectedLight is IndirectLight,
          onTap: () => cubit.selectLight(IndirectLight()),
        ),
        const SizedBox(height: 16),
        _buildOptionCard(
          context,
          title: "Plein soleil / Direct",
          subtitle: "Soleil direct plusieurs heures par jour",
          icon: LucideIcons.sun,
          isSelected: selectedLight is DirectLight,
          onTap: () => cubit.selectLight(DirectLight()),
        ),
      ],
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.greenLight.withValues(alpha: 0.15)
              : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.greenDark : AppColors.greyLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.greenDark
                    : AppColors.greenLight.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.white : AppColors.greenDark,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.greyDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const bold = FontWeight.bold;
