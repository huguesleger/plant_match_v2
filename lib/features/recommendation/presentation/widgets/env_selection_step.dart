import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/recommendation/domain/entities/recommendation_answers.dart';
import 'package:plant_match_v2/features/recommendation/presentation/cubit/recommendation_cubit.dart';

class EnvSelectionStep extends StatelessWidget {
  final RecommendationAnswers answers;

  const EnvSelectionStep({
    super.key,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RecommendationCubit>();
    final selectedEnv = answers.environment.toNullable();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Où placeras-tu ta plante ?",
          style: TextStyle(
            fontSize: 20,
            fontWeight: bold,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Choisis l'environnement principal pour adapter les suggestions.",
          style: TextStyle(fontSize: 14, color: AppColors.greyDark),
        ),
        const SizedBox(height: 24),
        _buildOptionCard(
          context,
          title: "En intérieur",
          subtitle: "Salon, chambre, bureau...",
          icon: LucideIcons.house,
          isSelected: selectedEnv is IndoorEnv,
          onTap: () => cubit.selectEnvironment(IndoorEnv()),
        ),
        const SizedBox(height: 16),
        _buildOptionCard(
          context,
          title: "En extérieur",
          subtitle: "Balcon, terrasse, jardin...",
          icon: LucideIcons.trees,
          isSelected: selectedEnv is OutdoorEnv,
          onTap: () => cubit.selectEnvironment(OutdoorEnv()),
        ),
        const SizedBox(height: 16),
        _buildOptionCard(
          context,
          title: "Les deux",
          subtitle: "Une plante polyvalente",
          icon: LucideIcons.compass,
          isSelected: selectedEnv is BothEnv,
          onTap: () => cubit.selectEnvironment(BothEnv()),
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
