import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_header_slider.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/user/detail_plant/utils/detail_plant_loader.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/contact_owner_button.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/content_header.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/detail_plant_body.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/favorite_circle_button.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/share_plant_button.dart';

class DetailPlant extends StatefulWidget {
  const DetailPlant({
    super.key,
    required this.catalog,
    this.owner = const None(),
  });

  final Catalog catalog;
  final Option<ProfilUser> owner;

  @override
  State<DetailPlant> createState() => _DetailPlantState();
}

class _DetailPlantState extends State<DetailPlant> {
  late final Future<Option<DetailPlantData>> _data;

  @override
  void initState() {
    super.initState();
    _data = DetailPlantLoader.load(
      catalog: widget.catalog,
      owner: widget.owner,
      currentUserId: context.read<AuthCubit>().userId ?? '',
    ).run();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBarHeaderSlider(
          headerHeight: 240,
          content: ContentHeader(images: widget.catalog.images),
          onPressed: () => Navigator.pop(context, true),
          styleIconButton: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: AppColors.white,
          ),
          actions: [
            SharePlantButton(catalog: widget.catalog),
            const SizedBox(width: 8),
            FavoriteCircleButton(
              catalog: widget.catalog,
              currentUserId: context.read<AuthCubit>().userId,
            ),
          ],
        ),
        body: DetailPlantBody(data: _data),
        bottomNavigationBar: ContactOwnerButton(
          catalog: widget.catalog,
          owner: widget.owner,
        ),
      );
}
