import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/badge/badge_pill.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/catalog_detail/catalog_detail_page_route.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_cubit.dart';

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
          onTap: () => _onTap(context),
          child: SizedBox(
            height: 120,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CardImage(imageUrl: catalog.images.isNotEmpty ? catalog.images.first : null),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _CardHeader(catalog: catalog),
                        _CardDescription(description: catalog.description),
                        _CardBadges(catalog: catalog),
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
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CatalogDetailPageRoute(catalog: catalog)),
    );

    if (result == true && context.mounted) {
      final userId = context.read<AuthCubit>().userId;
      if (userId != null) {
        context.read<CatalogCubit>().getCatalogsByUserId(userId);
      }
    }
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({this.imageUrl});
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imageUrl != null && imageUrl!.startsWith('http')
          ? Image.network(imageUrl!, height: 100, width: 80, fit: BoxFit.cover)
          : const Image(
              image: AssetImage('assets/images/empty_picture.png'),
              height: 100,
              width: 80,
              fit: BoxFit.cover,
            ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.catalog});
  final Catalog catalog;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            catalog.name.toCapitalize(),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        BadgePill(
          text: Text(
            catalog.status.label,
            style: TextStyle(fontSize: 12, color: catalog.status.textColor),
          ),
          badgeColor: catalog.status.badgeColor,
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
      description.isNotEmpty ? description : 'Aucune description',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 12, color: Colors.grey),
    );
  }
}

class _CardBadges extends StatelessWidget {
  const _CardBadges({required this.catalog});
  final Catalog catalog;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          BadgePill(
            text: Text(
              catalog.environment.envName,
              style: const TextStyle(fontSize: 12, color: AppColors.greenDark),
            ),
            badgeColor: AppColors.greenLight.withValues(alpha: 0.2),
          ),
          const SizedBox(width: 8),
          ...catalog.family.map((f) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: BadgePill(
                  text: Text(
                    f.familyName,
                    style: const TextStyle(fontSize: 12, color: AppColors.greenDark),
                  ),
                  badgeColor: AppColors.greenLight.withValues(alpha: 0.2),
                ),
              )),
        ],
      ),
    );
  }
}
