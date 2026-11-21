import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/util/family_image.dart';
import 'package:plant_match_v2/features/home/domain/entities/family_overview.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeFamilyTile extends StatelessWidget {
  const HomeFamilyTile({
    super.key,
    required this.overview,
    required this.onPressed,
  });

  final FamilyOverview overview;
  final VoidCallback onPressed;

  static const double width = 120;
  static const double height = 150;

  @override
  Widget build(BuildContext context) => Skeleton.leaf(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                overview.family.image.image(fit: BoxFit.cover),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.4, 1],
                      colors: [
                        Colors.transparent,
                        AppColors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: _Label(overview: overview),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(onTap: onPressed),
                ),
              ],
            ),
          ),
        ),
      );
}

class _Label extends StatelessWidget {
  const _Label({required this.overview});

  final FamilyOverview overview;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            overview.family.familyName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: AppTypo.textS,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          Text(
            overview.isEmpty
                ? t.home.families.empty
                : t.home.families.count(n: overview.count),
            style: TextStyle(
              fontSize: AppTypo.textXs,
              color: AppColors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      );
}
