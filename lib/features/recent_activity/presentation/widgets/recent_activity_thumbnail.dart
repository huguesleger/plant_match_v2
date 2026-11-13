import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/network_image/app_network_image.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RecentActivityThumbnail extends StatelessWidget {
  const RecentActivityThumbnail({super.key, required this.catalog});

  final Catalog catalog;

  static const double _size = 48;

  @override
  Widget build(BuildContext context) => Skeleton.leaf(
        child: Container(
          width: _size,
          height: _size,
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: catalog.images.firstOption.match(
              () => const Icon(
                LucideIcons.image,
                color: AppColors.greyMedium,
                size: 20,
              ),
              (url) => AppNetworkImage(url: url),
            ),
          ),
        ),
      );
}
