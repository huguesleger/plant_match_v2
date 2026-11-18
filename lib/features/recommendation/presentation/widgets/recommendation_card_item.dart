import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/widgets/network_image/app_network_image.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/badge/badge_pill.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/recommendation/domain/entities/scored_plant.dart';
import 'package:plant_match_v2/features/recommendation/presentation/widgets/match_reason_label.dart';
import 'package:plant_match_v2/features/user/detail_plant/detail_plant.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RecommendationCardItem extends StatelessWidget {
  const RecommendationCardItem({super.key, required this.scored});

  final ScoredPlant scored;

  Catalog get catalog => scored.plant;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Material(
        elevation: 6,
        shadowColor: AppColors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        color: AppColors.white,
        child: InkWell(
          onTap: () => _onTap(context),
          child: SizedBox(
            height: 120,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CardImage(
                    imageUrl: catalog.images.firstOption,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _CardHeader(scored: scored),
                        _CardDescription(description: catalog.description),
                        _CardBadges(scored: scored),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailPlant(catalog: catalog),
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({required this.imageUrl});
  final Option<String> imageUrl;

  @override
  Widget build(BuildContext context) {
    final imageOpt = imageUrl.filter((url) => url.startsWith('http'));

    return Skeleton.leaf(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: imageOpt.match(
          () => Assets.res.images.emptyPicture.image(
            height: 100,
            width: 80,
            fit: BoxFit.cover,
          ),
          (url) => AppNetworkImage(
            url: url,
            height: const Some(100),
            width: const Some(80),
          ),
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.scored});
  final ScoredPlant scored;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            scored.plant.name.toCapitalize(),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        BadgePill(
          text: Text(
            t.recommendation.card.score(score: scored.score),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          badgeColor: AppColors.greenDark,
        ),
      ],
    );
  }
}

class _CardDescription extends StatelessWidget {
  const _CardDescription({required this.description});
  final String description;

  @override
  Widget build(BuildContext context) {
    return Text(
      description.isNotEmpty
          ? description
          : t.recommendation.card.no_description,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 12, color: Colors.grey),
    );
  }
}

class _CardBadges extends StatelessWidget {
  const _CardBadges({required this.scored});
  final ScoredPlant scored;

  List<String> get _labels => [
        ...scored.reasons.map((reason) => reason.label),
        ...scored.plant.family.map((family) => family.familyName),
      ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _labels
            .map(
              (label) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: BadgePill(
                  text: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.greenDark,
                    ),
                  ),
                  badgeColor: AppColors.greenLight.withValues(alpha: 0.2),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
