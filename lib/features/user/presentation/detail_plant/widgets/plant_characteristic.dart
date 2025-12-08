import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';

class PlantCharacteristic extends StatelessWidget {
  const PlantCharacteristic({
    super.key,
    required this.lighting,
    required this.watering,
    required this.levelMaintenance,
  });

  final Lighting lighting;
  final Watering watering;
  final LevelMaintenance levelMaintenance;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingAll,
      decoration: BoxDecoration(
        color: AppColors.greenLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: AppColors.greenDark.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Container(
                  color: AppColors.greenLight.withValues(alpha: 0.5),
                  width: 35,
                  height: 35,
                  child: const Icon(
                    LucideIcons.sun,
                    color: AppColors.blueGreen,
                    size: AppTypo.text,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lighting.lightingName,
                    style: const TextStyle(
                        fontSize: AppTypo.textXs, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'lumière',
                    style: TextStyle(
                        fontSize: AppTypo.textXs, color: AppColors.grey),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Container(
                  color: AppColors.greenLight.withValues(alpha: 0.5),
                  width: 35,
                  height: 35,
                  child: const Icon(
                    LucideIcons.droplet,
                    color: AppColors.blueGreen,
                    size: AppTypo.text,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(watering.wateringName,
                      style: const TextStyle(
                        fontSize: AppTypo.textXs,
                        fontWeight: FontWeight.bold,
                      )),
                  const Text(
                    'arrosage',
                    style: TextStyle(
                      fontSize: AppTypo.textXs,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Container(
                  color: AppColors.greenLight.withValues(alpha: 0.5),
                  width: 35,
                  height: 35,
                  child: const Icon(
                    LucideIcons.shovel,
                    color: AppColors.blueGreen,
                    size: AppTypo.text,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    levelMaintenance.levelName,
                    style: const TextStyle(
                      fontSize: AppTypo.textXs,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('entretien',
                      style: TextStyle(
                        fontSize: AppTypo.textXs,
                        color: AppColors.grey,
                      )),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
