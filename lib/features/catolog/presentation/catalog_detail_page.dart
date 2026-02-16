import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_header_slider.dart';
import 'package:plant_match_v2/core/widgets/badge/badge_pill.dart';
import 'package:plant_match_v2/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded_with_icon.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded_with_icon.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catolog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/features/catolog/presentation/edit_catalog_page.dart';

class CatalogDetailPage extends StatefulWidget {
  const CatalogDetailPage({super.key, required this.catalog});

  final Catalog catalog;

  @override
  State<CatalogDetailPage> createState() => _CatalogDetailPageState();
}

class _CatalogDetailPageState extends State<CatalogDetailPage> {
  int _currentIndex = 0;
  late Catalog _catalog;

  @override
  void initState() {
    super.initState();
    _catalog = widget.catalog;
  }

  @override
  Widget build(BuildContext context) {
    final images = _catalog.images;

    return Scaffold(
      appBar: AppBarHeaderSlider(
        headerHeight: 420,
        content: Stack(
          children: [
            images.isNotEmpty
                ? CarouselSlider.builder(
                    itemCount: images.length,
                    options: CarouselOptions(
                      height: 420,
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
                    bottom: 100,
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
            Positioned(
              top: 320,
              right: 0,
              left: 0,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: AppSpacing.paddingHorizontal +
                      const EdgeInsets.symmetric(vertical: 25),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _catalog.name.toCapitalize(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'plante ${_catalog.environment.envName}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 5),
                              ClipOval(
                                child: Container(
                                  color: AppColors.greenLight
                                      .withValues(alpha: 0.5),
                                  width: 25,
                                  height: 25,
                                  child: Icon(
                                    _catalog.environment == Environment.outdoor
                                        ? LucideIcons.trees
                                        : LucideIcons.house,
                                    color: AppColors.blueGreen,
                                    size: AppTypo.textS,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: BadgePill(
                          text: Text(
                            _catalog.status.label,
                            style: TextStyle(
                              fontSize: 12,
                              color: _catalog.status.textColor,
                            ),
                          ),
                          badgeColor: _catalog.status.badgeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.pop(context, true);
        },
        styleIconButton: IconButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: AppColors.white,
        ),
      ),
      body: Padding(
        padding: AppSpacing.paddingHorizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Container(
              width: double.infinity,
              padding: AppSpacing.paddingAll,
              decoration: BoxDecoration(
                color: AppColors.greenLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: AppColors.greenDark.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipOval(
                        child: Container(
                          color: AppColors.greenLight.withValues(alpha: 0.5),
                          width: 35,
                          height: 35,
                          child: const Icon(
                            LucideIcons.sun,
                            color: AppColors.blueGreen,
                            size: AppTypo.text,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _catalog.lighting.lightingName,
                            style: const TextStyle(
                                fontSize: AppTypo.textXs,
                                fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'lumière',
                            style: TextStyle(
                                fontSize: AppTypo.textXs, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipOval(
                        child: Container(
                          color: AppColors.greenLight.withValues(alpha: 0.5),
                          width: 35,
                          height: 35,
                          child: const Icon(
                            LucideIcons.droplet,
                            color: AppColors.blueGreen,
                            size: AppTypo.text,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_catalog.watering.wateringName,
                              style: const TextStyle(
                                fontSize: AppTypo.textXs,
                                fontWeight: FontWeight.bold,
                              )),
                          const Text(
                            'arrosage',
                            style: TextStyle(
                              fontSize: AppTypo.textXs,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipOval(
                        child: Container(
                          color: AppColors.greenLight.withValues(alpha: 0.5),
                          width: 35,
                          height: 35,
                          child: const Icon(
                            LucideIcons.shovel,
                            color: AppColors.blueGreen,
                            size: AppTypo.text,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _catalog.levelMaintenance.levelName,
                            style: const TextStyle(
                              fontSize: AppTypo.textXs,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('entretien',
                              style: TextStyle(
                                fontSize: AppTypo.textXs,
                                color: Colors.grey,
                              )),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: AppTypo.textXl,
                fontWeight: FontWeight.bold,
                color: AppColors.greyDark,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              _catalog.description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        child: Row(
          children: [
            Expanded(
              child: ButtonOutlinedRoundedWithIcon(
                text: 'Supprimer',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Supprimer la plante'),
                      content: Text(
                        'Êtes-vous sûr de vouloir supprimer "${_catalog.name}" ?\n\n'
                        'Cette action est irréversible.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Annuler'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(ctx);
                            final userId = _catalog.userId;
                            await context
                                .read<CatalogCubit>()
                                .deleteCatalog(_catalog.catalogId!, userId);
                            if (context.mounted) {
                              Navigator.pop(context, true);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Supprimer'),
                        ),
                      ],
                    ),
                  );
                },
                borderColor: AppColors.blueGreen,
                textColor: AppColors.blueGreen,
                iconAlignment: IconAlignment.start,
                icon:
                    const Icon(LucideIcons.trash_2, color: AppColors.blueGreen),
              ),
            ),
            if (_catalog.status != CatalogStatus.archived) ...[
              const SizedBox(width: 12),
              Expanded(
                child: ButtonRoundedWithIcon(
                  text: 'Modifier',
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditCatalogPage(catalog: _catalog),
                      ),
                    );
                    if (result == true && context.mounted) {
                      final updatedCatalog = await context
                          .read<CatalogCubit>()
                          .getCatalogById(_catalog.catalogId!);

                      if (mounted) {
                        setState(() {
                          _catalog = updatedCatalog!;
                        });
                      }
                    }
                  },
                  bgColor: AppColors.greenLight,
                  textColor: AppColors.blueGreen,
                  iconAlignment: IconAlignment.start,
                  icon: const Icon(LucideIcons.pencil,
                      color: AppColors.blueGreen),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
