import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_header_slider.dart';
import 'package:plant_match_v2/core/widgets/badge/badge_pill.dart';
import 'package:plant_match_v2/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded_with_icon.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded_with_icon.dart';
import 'package:plant_match_v2/features/catalog/catalog_edit/catalog_edit_page_route.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_cubit.dart';

class CatalogDetailScreen extends StatefulWidget {
  const CatalogDetailScreen({super.key, required this.catalog});
  final Catalog catalog;

  @override
  State<CatalogDetailScreen> createState() => _CatalogDetailScreenState();
}

class _CatalogDetailScreenState extends State<CatalogDetailScreen> {
  int _currentIndex = 0;
  late Catalog _catalog;

  @override
  void initState() {
    super.initState();
    _catalog = widget.catalog;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarHeaderSlider(
        headerHeight: 420,
        content: _buildHeaderSlider(),
        onPressed: () => Navigator.pop(context, true),
        styleIconButton: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: AppColors.white,
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildHeaderSlider() {
    final images = _catalog.images;
    return Stack(
      children: [
        images.isNotEmpty ? _buildCarousel(images) : _buildEmptyPicture(),
        if (images.length > 1) _buildPageIndicator(images.length),
        _buildHeaderInfo(),
      ],
    );
  }

  Widget _buildCarousel(List<String> images) {
    return CarouselSlider.builder(
      itemCount: images.length,
      options: CarouselOptions(
        height: 420,
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
  }

  Widget _buildEmptyPicture() => const Image(
        image: AssetImage('res/images/empty_picture.png'),
        fit: BoxFit.cover,
        width: double.infinity,
      );

  Widget _buildPageIndicator(int count) => Positioned(
        bottom: 100,
        right: 10,
        child: BadgePill(
          text: SizedBox(
            width: 20,
            child: Center(
              child: Text('${_currentIndex + 1}/$count', style: const TextStyle(fontSize: 11)),
            ),
          ),
          badgeColor: AppColors.white.withValues(alpha: 0.5),
        ),
      );

  Widget _buildHeaderInfo() => Positioned(
        top: 320,
        right: 0,
        left: 0,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          child: Padding(
            padding: AppSpacing.paddingHorizontal + const EdgeInsets.symmetric(vertical: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBasicInfo(),
                BadgePill(
                  text: Text(_catalog.status.label, style: TextStyle(fontSize: 12, color: _catalog.status.textColor)),
                  badgeColor: _catalog.status.badgeColor,
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildBasicInfo() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_catalog.name.toCapitalize(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Text('plante ${_catalog.environment.envName}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(width: 5),
              _buildEnvironmentIcon(),
            ],
          ),
        ],
      );

  Widget _buildEnvironmentIcon() => ClipOval(
        child: Container(
          color: AppColors.greenLight.withValues(alpha: 0.5),
          width: 25,
          height: 25,
          child: Icon(
            _catalog.environment == Environment.outdoor ? LucideIcons.trees : LucideIcons.house,
            color: AppColors.blueGreen,
            size: AppTypo.textS,
          ),
        ),
      );

  Widget _buildBody() => Padding(
        padding: AppSpacing.paddingHorizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            _buildCharacteristicsCard(),
            const SizedBox(height: 40),
            const Text('Description',
                style: TextStyle(fontSize: AppTypo.textXl, fontWeight: FontWeight.bold, color: AppColors.greyDark)),
            const SizedBox(height: 15),
            Text(_catalog.description, style: const TextStyle(fontSize: 16, color: Colors.black87)),
          ],
        ),
      );

  Widget _buildCharacteristicsCard() => Container(
        width: double.infinity,
        padding: AppSpacing.paddingAll,
        decoration: BoxDecoration(
          color: AppColors.greenLight.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: AppColors.greenDark.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _CardDetailItem(icon: LucideIcons.sun, label: 'lumière', value: _catalog.lighting.lightingName),
            _CardDetailItem(icon: LucideIcons.droplet, label: 'arrosage', value: _catalog.watering.wateringName),
            _CardDetailItem(icon: LucideIcons.shovel, label: 'entretien', value: _catalog.levelMaintenance.levelName),
          ],
        ),
      );

  Widget _buildBottomBar(BuildContext context) => BottomBar(
        child: Row(
          children: [
            Expanded(child: _DeleteButton(catalog: _catalog)),
            if (_catalog.status != CatalogStatus.archived) ...[
              const SizedBox(width: 12),
              Expanded(child: _EditButton(catalog: _catalog, onUpdate: (c) => setState(() => _catalog = c))),
            ],
          ],
        ),
      );
}

class _CardDetailItem extends StatelessWidget {
  const _CardDetailItem({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(
          child: Container(
            color: AppColors.greenLight.withValues(alpha: 0.5),
            width: 35,
            height: 35,
            child: Icon(icon, color: AppColors.blueGreen, size: AppTypo.text),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontSize: AppTypo.textXs, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: AppTypo.textXs, color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.catalog});
  final Catalog catalog;

  @override
  Widget build(BuildContext context) {
    return ButtonOutlinedRoundedWithIcon(
      text: 'Supprimer',
      onPressed: () => _showDeleteDialog(context),
      borderColor: AppColors.blueGreen,
      textColor: AppColors.blueGreen,
      iconAlignment: IconAlignment.start,
      icon: const Icon(LucideIcons.trash_2, color: AppColors.blueGreen),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la plante'),
        content: Text('Êtes-vous sûr de vouloir supprimer "${catalog.name}" ?\n\nCette action est irréversible.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final catalogCubit = context.read<CatalogCubit>();
              final userPointsCubit = context.read<UserPointsCubit>();

              final result = await catalogCubit
                  .deleteCatalog(catalog.catalogId.getOrElse(() => ''), catalog.userId)
                  .run();

              result.match(
                (failure) => null,
                (remainingCount) {
                  if (remainingCount == 0) {
                    userPointsCubit.updateUserPoints(catalog.userId, -25);
                  }
                },
              );

              navigator.pop(); // dialog
              navigator.pop(true); // screen
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
  }
}

class _EditButton extends StatelessWidget {
  const _EditButton({required this.catalog, required this.onUpdate});
  final Catalog catalog;
  final Function(Catalog) onUpdate;

  @override
  Widget build(BuildContext context) {
    return ButtonRoundedWithIcon(
      text: 'Modifier',
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CatalogEditPageRoute(catalog: catalog)),
        );
        if (result == true && context.mounted) {
          final getResult = await context.read<CatalogCubit>().getCatalogById(catalog.catalogId.getOrElse(() => '')).run();
          getResult.match((_) => null, (updatedCatalog) => onUpdate(updatedCatalog));
        }
      },
      bgColor: AppColors.greenLight,
      textColor: AppColors.blueGreen,
      iconAlignment: IconAlignment.start,
      icon: const Icon(LucideIcons.pencil, color: AppColors.blueGreen),
    );
  }
}
