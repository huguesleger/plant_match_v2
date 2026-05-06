import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/badge/badge_pill.dart';

class ContentHeader extends StatefulWidget {
  const ContentHeader({super.key, required this.images});

  final List<String> images;

  @override
  State<ContentHeader> createState() => _ContentHeaderState();
}

class _ContentHeaderState extends State<ContentHeader> {
  int _currentIndex = 0;
  late List<String> _imageCatalog;

  @override
  void initState() {
    super.initState();
    _imageCatalog = widget.images;
  }

  @override
  Widget build(BuildContext context) {
    final images = _imageCatalog;

    return Stack(
      children: [
        images.isNotEmpty
            ? CarouselSlider.builder(
                itemCount: images.length,
                options: CarouselOptions(
                  height: 320,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return Image.network(
                    images[index],
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  );
                },
              )
            : Assets.res.images.emptyPicture.image(
                fit: BoxFit.cover,
                width: double.infinity,
              ),
        images.length > 1
            ? Positioned(
                bottom: 10,
                right: 10,
                child: BadgePill(
                  text: SizedBox(
                    width: 20,
                    child: Center(
                      child: Text(
                        '${_currentIndex + 1}/${images.length}',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                  badgeColor: AppColors.white.withValues(alpha: 0.5),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
