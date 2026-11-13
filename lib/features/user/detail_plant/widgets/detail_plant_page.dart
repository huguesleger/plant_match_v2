import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_header_slider.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/contact_owner_button.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/content_header.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/favorite_circle_button.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/share_plant_button.dart';

class DetailPlantPage extends StatelessWidget {
  const DetailPlantPage({
    super.key,
    required this.catalog,
    required this.owner,
    required this.body,
  });

  final Catalog catalog;
  final Option<ProfilUser> owner;
  final Widget body;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBarHeaderSlider(
          headerHeight: 240,
          content: ContentHeader(images: catalog.images),
          onPressed: () => Navigator.pop(context, true),
          styleIconButton: Some(IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: AppColors.white,
          )),
          actions: Some([
            SharePlantButton(catalog: catalog),
            const SizedBox(width: 8),
            FavoriteCircleButton(
              catalog: catalog,
              currentUserId: context.read<AuthCubit>().userId,
            ),
          ]),
        ),
        body: body,
        bottomNavigationBar: ContactOwnerButton(
          catalog: catalog,
          owner: owner,
        ),
      );
}
