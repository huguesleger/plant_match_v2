import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_header_slider.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
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
  late Future<Option<DetailPlantData>> _data;

  String get _currentUserId => context.read<AuthCubit>().userId ?? '';

  @override
  void initState() {
    super.initState();
    DetailPlantLoader.incrementViews(widget.catalog, _currentUserId).run();
    _data = _load();
  }

  Future<Option<DetailPlantData>> _load() => DetailPlantLoader.load(
        catalog: widget.catalog,
        owner: widget.owner,
        currentUserId: _currentUserId,
      ).run();

  void _retry() => setState(() => _data = _load());

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<Option<DetailPlantData>>(
        future: _data,
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.done
                ? Option.fromNullable(snapshot.data).flatMap((d) => d).match(
                      () => ErrorPage(
                        errorMessage: t.user.detail_plant.load_error,
                        onRetry: _retry,
                      ),
                      (loaded) => _page(loaded.catalog, Some(loaded)),
                    )
                : _page(widget.catalog, const None()),
      );

  Widget _page(Catalog catalog, Option<DetailPlantData> data) => Scaffold(
        appBar: AppBarHeaderSlider(
          headerHeight: 240,
          content: ContentHeader(images: catalog.images),
          onPressed: () => Navigator.pop(context, true),
          styleIconButton: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: AppColors.white,
          ),
          actions: [
            SharePlantButton(catalog: catalog),
            const SizedBox(width: 8),
            FavoriteCircleButton(
              catalog: catalog,
              currentUserId: context.read<AuthCubit>().userId,
            ),
          ],
        ),
        body: DetailPlantBody(data: data),
        bottomNavigationBar: ContactOwnerButton(
          catalog: catalog,
          owner: data.map((loaded) => loaded.owner).alt(() => widget.owner),
        ),
      );
}
