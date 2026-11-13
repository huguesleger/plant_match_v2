import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/network_image/app_network_image.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExchangePlantImage extends StatelessWidget {
  const ExchangePlantImage({super.key, required this.plant});

  final Catalog plant;

  static const double _width = 80;
  static const double _height = 96;

  Widget _placeholder() => Container(
        width: _width,
        height: _height,
        color: AppColors.greyUltraLight,
        child: const Icon(
          Icons.eco_rounded,
          color: AppColors.greyLight,
          size: 32,
        ),
      );

  @override
  Widget build(BuildContext context) => Skeleton.leaf(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: plant.images.firstOption.match(
            _placeholder,
            (url) => AppNetworkImage(
              url: url,
              width: const Some(_width),
              height: const Some(_height),
              errorWidget: Some(_placeholder()),
            ),
          ),
        ),
      );
}
