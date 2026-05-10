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
import 'package:plant_match_v2/features/chat_plant/data/firebase_chat_plant.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/chat_plant_page_route.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/badge_family.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/badge_offer_type.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/content_header.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/plant_characteristic.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/plant_environment.dart';

class DetailPlant extends StatelessWidget {
  const DetailPlant({super.key, required this.catalog});

  final Catalog catalog;

  void openPlantChat(BuildContext context) {
    final userId = context.read<AuthCubit>().userId ?? '';
    if (userId.isEmpty) return;

    FirebaseFirestore.instance
        .collection('users')
        .doc(catalog.userId)
        .get()
        .then((userDoc) {
      final Option<Map<String, dynamic>> dataOpt =
          Option.fromNullable(userDoc.data());

      final String ownerName = dataOpt.match(
        () => t.user.detail_plant.owner_placeholder,
        (data) {
          final userName = Option.fromNullable(data['userName'] as String?)
              .filter((s) => s.trim().isNotEmpty);
          final fullName = Option.fromNullable(data['fullName'] as String?)
              .filter((s) => s.trim().isNotEmpty)
              .map((s) => s.split(' ').first);

          return userName.alt(() => fullName).getOrElse(() => t.user.detail_plant.owner_placeholder);
        },
      );

      final String? ownerAvatar = dataOpt
          .flatMap((data) => Option.fromNullable(data['profilImg'] as String?)
              .filter((s) => s.trim().isNotEmpty))
          .toNullable();

      final chatRepository = FirebaseChatPlant();
      chatRepository
          .getOrCreatePlantChat(
            currentUserId: userId,
            plantOwnerId: catalog.userId,
            plantId: catalog.catalogId.getOrElse(() => ''),
            plantName: catalog.name,
            plantDescription: catalog.description,
            plantImage: catalog.images.first,
            plantExchangeType: catalog.offerType,
          )
          .run()
          .then((result) {
        result.match(
          (failure) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(failure.message)),
              );
            }
          },
          (chatId) {
            if (!context.mounted) return;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatPlantPageRoute(
                  chatId: chatId,
                  plantId: catalog.catalogId.getOrElse(() => ''),
                  plantOwnerName: ownerName,
                  plantOwnerAvatar: ownerAvatar ?? '',
                ),
              ),
            );
          },
        );
      });
    });
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
              const SizedBox(height: 40),
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
