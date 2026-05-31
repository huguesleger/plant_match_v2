import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/avatar/avatar.dart';
import 'package:plant_match_v2/core/widgets/favorite_btn/favorite_btn.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class HomeCardPlant extends StatelessWidget {
  const HomeCardPlant({
    super.key,
    required this.catalog,
    required this.owner,
    required this.onPressed,
    this.distance,
  });

  final Catalog catalog;
  final ProfilUser owner;
  final VoidCallback onPressed;
  final double? distance;

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<AuthCubit>().userId ?? '';
    final isExchange = catalog.offerType == OfferType.exchange;
    final isImg = catalog.images.isNotEmpty;

    return Material(
      color: AppColors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 155,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  isImg
                      ? Image.network(catalog.images.first,
                          height: 120, width: 155, fit: BoxFit.cover)
                      : Container(
                          height: 120,
                          color: AppColors.greyLight,
                          child: const Icon(LucideIcons.image)),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            (isExchange ? AppColors.green : AppColors.blueGreen)
                                .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isExchange ? "Échange" : "Don",
                        style: TextStyle(
                          color: isExchange
                              ? AppColors.greenDark
                              : AppColors.blueGreen,
                          fontSize: AppTypo.textXxs,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: AppColors.white, shape: BoxShape.circle),
                      padding: const EdgeInsets.all(4),
                      child: FavoriteBtn(
                          catalog: catalog, currentUserId: currentUserId),
                    ),
                  ),
                  Positioned(
                    bottom: -15,
                    left: 12,
                    child: _HomeCardPlantAvatar(owner: owner),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 12, right: 12, bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      catalog.name.toCapitalize(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: AppTypo.textS,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black),
                    ),
                    const SizedBox(height: 4),
                    _HomeCardPlantInfo(owner: owner, distance: distance),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeCardPlantAvatar extends StatelessWidget {
  const _HomeCardPlantAvatar({required this.owner});

  final ProfilUser owner;

  @override
  Widget build(BuildContext context) {
    final displayName = owner.userName.getOrElse(() => owner.firstName);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
        border: Border.all(color: AppColors.white, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Avatar(
        imageUrl: owner.profilImg,
        name: displayName,
        radius: 14,
        imgSizeAvatar: 28,
      ),
    );
  }
}

class _HomeCardPlantInfo extends StatelessWidget {
  const _HomeCardPlantInfo({required this.owner, this.distance});

  final ProfilUser owner;
  final double? distance;

  @override
  Widget build(BuildContext context) {
    final distText =
        distance != null ? '${distance!.toStringAsFixed(2)} km' : '2 km';
    final displayName = owner.userName.getOrElse(() => owner.firstName);
    return Row(
      children: [
        const Icon(
          LucideIcons.map_pin,
          color: AppColors.green,
          size: 12,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            "$distText • $displayName",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: AppTypo.textXxs, color: AppColors.greyMedium),
          ),
        ),
      ],
    );
  }
}
