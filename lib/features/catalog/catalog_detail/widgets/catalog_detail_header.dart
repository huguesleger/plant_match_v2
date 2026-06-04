import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/badge/badge_pill.dart';

class CatalogDetailHeader extends StatefulWidget {
  const CatalogDetailHeader({super.key, required this.images});
  final List<String> images;

  @override
  State<CatalogDetailHeader> createState() => _CatalogDetailHeaderState();
}

class _CatalogDetailHeaderState extends State<CatalogDetailHeader> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.images;
    return Stack(
      children: [
        images.isNotEmpty ? _buildCarousel(images) : _buildEmptyPicture(),
        if (images.length > 1) _buildPageIndicator(images.length),
      ],
    );
  }

  Widget _buildCarousel(List<String> images) => CarouselSlider.builder(
        itemCount: images.length,
        options: CarouselOptions(
          height: 320,
          viewportFraction: 1.0,
          enableInfiniteScroll: false,
          onPageChanged: (index, _) => setState(() => _currentIndex = index),
        ),
        itemBuilder: (context, index, _) => Image.network(
          images[index],
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        ),
      );

  Widget _buildEmptyPicture() => Assets.res.images.emptyPicture.image(
        fit: BoxFit.cover,
        width: double.infinity,
      );

  Widget _buildPageIndicator(int count) => Positioned(
        bottom: 16,
        right: 16,
        child: BadgePill(
          text: SizedBox(
            width: 20,
            child: Center(
              child: Text(
                '${_currentIndex + 1}/$count',
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ),
          badgeColor: AppColors.white.withValues(alpha: 0.5),
        ),
      );
}
