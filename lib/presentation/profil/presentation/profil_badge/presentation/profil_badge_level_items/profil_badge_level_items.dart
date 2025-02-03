import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class ProfilBadgeLevelItems extends StatelessWidget {
  const ProfilBadgeLevelItems({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Card.filled(
          color: AppColors.greenDark.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: SizedBox(
              width: 130,
              height: 130,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.white),
                    child: Icon(
                      Icons.star,
                      color: AppColors.greenDark,
                      size: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Niveau 1',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '0/1000 points',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
