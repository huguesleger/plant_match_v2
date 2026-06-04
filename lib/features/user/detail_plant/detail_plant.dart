import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_header_slider.dart';
import 'package:plant_match_v2/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded_with_icon.dart';
import 'package:plant_match_v2/core/widgets/favorite_btn/favorite_btn.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/chat_plant_page_route.dart';
import 'package:plant_match_v2/features/user/data/firebase_user.dart';
import 'package:plant_match_v2/features/catalog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/badge_family.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/badge_offer_type.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/content_header.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/owner_profile_section.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/plant_metrics_card.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/plant_characteristic.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/plant_environment.dart';

class DetailPlant extends StatefulWidget {
  const DetailPlant({
    super.key,
    required this.catalog,
    this.owner,
  });

  final Catalog catalog;
  final ProfilUser? owner;

  @override
  State<DetailPlant> createState() => _DetailPlantState();
}

class _DetailPlantState extends State<DetailPlant> {
  @override
  void initState() {
    super.initState();
  }

  void openPlantChat(BuildContext context) {
    final userId = context.read<AuthCubit>().userId ?? '';
    if (userId.isEmpty) return;

    if (widget.owner != null) {
      _startChat(context, userId, widget.owner!);
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.catalog.userId)
          .get()
          .then((userDoc) {
        if (!context.mounted) return;
        final data = userDoc.data();
        if (data == null) return;
        final profilUser = ProfilUser.fromJson({
          ...data,
          'uid': userDoc.id,
        });
        _startChat(context, userId, profilUser);
      });
    }
  }

  void _startChat(
    BuildContext context,
    String currentUserId,
    ProfilUser plantOwner,
  ) {
    final ownerName = plantOwner.userName
        .alt(() => Some(plantOwner.firstName))
        .filter((s) => s.trim().isNotEmpty)
        .getOrElse(() => t.user.detail_plant.owner_placeholder);

    final ownerAvatar =
        plantOwner.profilImg.trim().isNotEmpty ? plantOwner.profilImg : null;

    final ids = [currentUserId, widget.catalog.userId]..sort();
    final chatId =
        '${widget.catalog.catalogId.getOrElse(() => '')}_${ids[0]}_${ids[1]}';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPlantPageRoute(
          chatId: chatId,
          plantId: widget.catalog.catalogId.getOrElse(() => ''),
          plantOwnerName: ownerName,
          plantOwnerAvatar: ownerAvatar ?? '',
          otherUserId: widget.catalog.userId,
        ),
      ),
    );
  }

  Future<(Either<Failure, Option<Catalog>>, Either<Failure, ProfilUser>, Either<Failure, ProfilUser>?)> _loadData(
    String currentUserId,
  ) async {
    final catalogId = widget.catalog.catalogId.getOrElse(() => '');

    if (currentUserId.isNotEmpty && currentUserId != widget.catalog.userId && catalogId.isNotEmpty) {
      await FirebaseCatalogRepository().incrementCatalogViews(catalogId).run();
    }

    final catalogFuture = catalogId.isNotEmpty
        ? FirebaseCatalogRepository().getCatalogById(catalogId).run()
        : Future.value(Right<Failure, Option<Catalog>>(Some(widget.catalog)));

    final ownerFuture = widget.owner != null
        ? Future.value(Right<Failure, ProfilUser>(widget.owner!))
        : FirebaseUser().getUserUid(widget.catalog.userId).run();

    final currentUserFuture = currentUserId.isNotEmpty
        ? FirebaseUser().getUserUid(currentUserId).run()
        : Future.value(const Left<Failure, ProfilUser>(UnexpectedFailure('No user')));

    final results = await Future.wait([catalogFuture, ownerFuture, currentUserFuture]);

    return (
      results[0] as Either<Failure, Option<Catalog>>,
      results[1] as Either<Failure, ProfilUser>,
      results[2] as Either<Failure, ProfilUser>?,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<AuthCubit>().userId;

    return Scaffold(
      appBar: AppBarHeaderSlider(
        headerHeight: 240,
        content: ContentHeader(images: widget.catalog.images),
        onPressed: () {
          Navigator.pop(context, true);
        },
        styleIconButton: IconButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: AppColors.white,
        ),
        actions: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              border: Border.fromBorderSide(
                BorderSide(color: AppColors.greyLight),
              ),
            ),
            padding: const EdgeInsets.all(6),
            child: FavoriteBtn(
              catalog: widget.catalog,
              currentUserId: currentUserId,
            ),
          ),
        ],
      ),
      body: FutureBuilder<(Either<Failure, Option<Catalog>>, Either<Failure, ProfilUser>, Either<Failure, ProfilUser>?)>(
        future: _loadData(currentUserId ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }
          if (snapshot.hasData) {
            final (catalogResult, ownerResult, currentUserResult) = snapshot.data!;
            
            final resolvedCatalog = catalogResult.match(
              (failure) => widget.catalog,
              (option) => option.getOrElse(() => widget.catalog),
            );

            return ownerResult.match(
              (failure) => const SizedBox.shrink(),
              (resolvedOwner) {
                final resolvedCurrentUser = currentUserResult?.match(
                  (failure) => null,
                  (profilUser) => profilUser,
                );
                return _buildContent(context, resolvedCatalog, resolvedOwner, resolvedCurrentUser);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: BottomBar(
        child: SizedBox(
          width: double.infinity,
          child: ButtonRoundedWithIcon(
            text: t.user.detail_plant.send_message,
            bgColor: AppColors.greenDark,
            textColor: AppColors.white,
            icon: const Icon(
              LucideIcons.message_square_text,
              color: AppColors.white,
              size: AppTypo.text,
            ),
            onPressed: () => openPlantChat(context),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Catalog resolvedCatalog,
    ProfilUser resolvedOwner,
    ProfilUser? currentUser,
  ) {
    return Padding(
      padding: AppSpacing.paddingHorizontal,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BadgeFamily(family: resolvedCatalog.family),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TitlePage(
                    title: resolvedCatalog.name.toCapitalize(),
                    fontSize: AppTypo.textXl,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                BadgeOfferType(
                  offerType: resolvedCatalog.offerType,
                ),
              ],
            ),
            PlantEnvironment(
              environment: resolvedCatalog.environment,
            ),
            const SizedBox(height: 20),
            PlantMetricsCard(
              catalog: resolvedCatalog,
              owner: resolvedOwner,
              currentUser: currentUser,
            ),
            const SizedBox(height: 20),
            Text(
              'Description',
              style: InterTextStyle.inter(
                AppTypo.textL,
                fontWeight: FontWeight.bold,
                color: AppColors.greyDark,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              resolvedCatalog.description.toCapitalize(),
              style: const TextStyle(
                fontSize: AppTypo.text,
                color: AppColors.greyDark,
              ),
            ),
            const SizedBox(height: 24),
            OwnerProfileSection(owner: resolvedOwner),
            const SizedBox(height: 24),
            Text(
              'Les informations clés',
              style: InterTextStyle.inter(
                AppTypo.textL,
                fontWeight: FontWeight.bold,
                color: AppColors.greyDark,
              ),
            ),
            const SizedBox(height: 24),
            PlantCharacteristic(
              lighting: resolvedCatalog.lighting,
              watering: resolvedCatalog.watering,
              levelMaintenance: resolvedCatalog.levelMaintenance,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
