import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/favorite_btn/favorite_btn.dart';
import 'package:plant_match_v2/core/widgets/network_image/app_network_image.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/around_me/home_card_plant_badge.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/home_user_avatar.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeCardPlantVisual extends StatelessWidget {
  const HomeCardPlantVisual({
    super.key,
    required this.catalog,
    required this.owner,
    required this.width,
  });

  final Catalog catalog;
  final ProfilUser owner;
  final double width;

  static const double _height = 120;

  @override
  Widget build(BuildContext context) => Stack(
        clipBehavior: Clip.none,
        children: [
          Skeleton.leaf(
            child: catalog.images.firstOption.match(
              () => Container(
                height: _height,
                width: width,
                color: AppColors.greyLight,
                child: const Icon(LucideIcons.image),
              ),
              (url) => AppNetworkImage(
                url: url,
                height: const Some(_height),
                width: Some(width),
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: HomeCardPlantBadge(offerType: catalog.offerType),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Skeleton.leaf(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: FavoriteBtn(
                  catalog: Some(catalog),
                  currentUserId: context.read<AuthCubit>().userId,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -15,
            left: 12,
            child: HomeUserAvatar(user: owner, radius: 14),
          ),
        ],
      );
}
