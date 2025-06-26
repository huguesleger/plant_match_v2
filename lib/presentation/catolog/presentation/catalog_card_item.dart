import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/badge/badge_pill.dart';
import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/util/environment_name.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/util/family_name.dart';

class CatalogCardItem extends StatelessWidget {
  const CatalogCardItem({super.key, required this.catalog});

  final Catalog catalog;

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
            onTap: () {},
            child: SizedBox(
              height: 120,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: catalog.images.isNotEmpty &&
                              catalog.images.first.startsWith('http')
                          ? Image.network(
                              catalog.images.first,
                              height: 100,
                              width: 80,
                              fit: BoxFit.cover,
                            )
                          : const Image(
                              image:
                                  AssetImage('assets/images/empty_picture.png'),
                              height: 100,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      catalog.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    LucideIcons.bookmark_x,
                                    color: AppColors.greyMedium,
                                    size: 22,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                catalog.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                BadgePill(
                                  text: Text(
                                    catalog.environment.envName,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.greenDark),
                                  ),
                                  badgeColor: AppColors.greenLight,
                                ),
                                const SizedBox(width: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: catalog.family.map((f) {
                                    return BadgePill(
                                      text: Text(
                                        f.familyName,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.greenDark),
                                      ),
                                      badgeColor: AppColors.greenLight,
                                    );
                                  }).toList(),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
