import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
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
import 'package:plant_match_v2/features/user/detail_plant/widgets/badge_family.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/badge_offer_type.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/content_header.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/owner_profile_section.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/plant_characteristic.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/plant_environment.dart';

class DetailPlant extends StatelessWidget {
  const DetailPlant({
    super.key,
    required this.catalog,
    this.owner,
  });

  final Catalog catalog;
  final ProfilUser? owner;

  void openPlantChat(BuildContext context) {
    final userId = context.read<AuthCubit>().userId ?? '';
    if (userId.isEmpty) return;

    if (owner != null) {
      _startChat(context, userId, owner!);
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(catalog.userId)
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

    final ids = [currentUserId, catalog.userId]..sort();
    final chatId =
        '${catalog.catalogId.getOrElse(() => '')}_${ids[0]}_${ids[1]}';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPlantPageRoute(
          chatId: chatId,
          plantId: catalog.catalogId.getOrElse(() => ''),
          plantOwnerName: ownerName,
          plantOwnerAvatar: ownerAvatar ?? '',
          otherUserId: catalog.userId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<AuthCubit>().userId;
    return Scaffold(
      appBar: AppBarHeaderSlider(
        headerHeight: 320,
        content: ContentHeader(images: catalog.images),
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
              catalog: catalog,
              currentUserId: currentUserId,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: AppSpacing.paddingHorizontal,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BadgeFamily(family: catalog.family),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TitlePage(
                      title: catalog.name.toCapitalize(),
                      fontSize: AppTypo.textXl,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  BadgeOfferType(
                    offerType: catalog.offerType,
                  ),
                ],
              ),
              PlantEnvironment(
                environment: catalog.environment,
              ),
              const SizedBox(height: 20),
              Text(
                catalog.description.toCapitalize(),
                style: const TextStyle(
                  fontSize: AppTypo.text,
                  color: AppColors.greyDark,
                ),
              ),
              const SizedBox(height: 24),
              owner != null
                  ? OwnerProfileSection(owner: owner!)
                  : FutureBuilder(
                      future: FirebaseUser().getUserUid(catalog.userId).run(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          return snapshot.data!.match(
                            (failure) => const SizedBox.shrink(),
                            (profilUser) =>
                                OwnerProfileSection(owner: profilUser),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
              const SizedBox(height: 24),
              const Text('Les informations clés'),
              const SizedBox(height: 24),
              PlantCharacteristic(
                lighting: catalog.lighting,
                watering: catalog.watering,
                levelMaintenance: catalog.levelMaintenance,
              ),
            ],
          ),
        ),
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
}
