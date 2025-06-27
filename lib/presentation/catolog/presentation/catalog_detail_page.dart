import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_header_slider.dart';
import 'package:plant_match_v2/core/widgets/badge/badge_pill.dart';
import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';

class CatalogDetailPage extends StatefulWidget {
  const CatalogDetailPage({super.key, required this.catalog});

  final Catalog catalog;

  @override
  State<CatalogDetailPage> createState() => _CatalogDetailPageState();
}

class _CatalogDetailPageState extends State<CatalogDetailPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.catalog.images;

    return Scaffold(
      appBar: AppBarHeaderSlider(
        content: Stack(
          children: [
            images.isNotEmpty
                ? CarouselSlider.builder(
                    itemCount: images.length,
                    options: CarouselOptions(
                      height: 215,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
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
                : const Image(
                    image: AssetImage('assets/images/empty_picture.png'),
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
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        styleIconButton: IconButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: AppColors.white,
        ),
      ),
      body: SafeArea(
        child: Text(
          widget.catalog.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
