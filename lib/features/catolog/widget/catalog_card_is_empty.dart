import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

class CatalogCardIsEmpty extends StatelessWidget {
  const CatalogCardIsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card.filled(
          color: AppColors.greenDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          margin: const EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: SizedBox(
              //height: 120,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: AppColors.white),
                        child: const Icon(
                          LucideIcons.flower_2,
                          color: AppColors.greenDark,
                          size: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Plantes & boutures',
                        style: TextStyle(
                          fontSize: AppTypo.textM,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(
                        //width: 220,
                        child: Text(
                          'Mon catalogue de ce que j’ai à partager',
                          style: TextStyle(
                            fontSize: AppTypo.textXs,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 20,
          top: -50,
          child: SizedBox(
            height: 174,
            child: Image.asset(
              'assets/images/empty_catalog.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
    /*  return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF579875),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.local_florist,
                            color: Color(0xFF579875),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Plantes & Boutures",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Mon catalogue de ce que j’ai à partager",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 80), // Espace réservé pour l'image
            ],
          ),
        ),
        // L'image qui dépasse de la carte
        Positioned(
          right: -10, // Décalage vers la droite
          top: -40, // Décalage vers le haut
          child: SizedBox(
            height: 172,
            child: Image.asset(
              'assets/images/empty_catalog.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );*/
  }
}
