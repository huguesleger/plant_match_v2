import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_header_slider.dart';
import 'package:plant_match_v2/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded_with_icon.dart';
import 'package:plant_match_v2/core/widgets/favorite_btn/favorite_btn.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/chat_plant/data/firebase_chat_plant.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/chat_plant_page.dart';
import 'package:plant_match_v2/features/user/presentation/detail_plant/widgets/badge_family.dart';
import 'package:plant_match_v2/features/user/presentation/detail_plant/widgets/badge_offer_type.dart';
import 'package:plant_match_v2/features/user/presentation/detail_plant/widgets/content_header.dart';
import 'package:plant_match_v2/features/user/presentation/detail_plant/widgets/plant_characteristic.dart';
import 'package:plant_match_v2/features/user/presentation/detail_plant/widgets/plant_environment.dart';

class DetailPlant extends StatelessWidget {
  const DetailPlant({super.key, required this.catalog});

  final Catalog catalog;

  Future<void> openPlantChat(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(catalog.userId)
        .get();

    final data = userDoc.data();
    final String ownerName = (data?['userName'] != null &&
            (data!['userName'] as String).trim().isNotEmpty)
        ? data['userName']
        : (data?['fullName'] != null &&
                (data!['fullName'] as String).trim().isNotEmpty)
            ? (data['fullName'] as String).split(' ').first
            : 'Propriétaire';

    final String? ownerAvatar =
        (data?['profilImg'] as String?)?.trim().isNotEmpty == true
            ? data!['profilImg']
            : null;

    final chatRepository = FirebaseChatPlant();
    final chatId = await chatRepository.getOrCreatePlantChat(
      currentUserId: currentUser.uid,
      plantOwnerId: catalog.userId,
      plantId: catalog.catalogId ?? '',
      plantName: catalog.name,
      plantDescription: catalog.description,
      plantImage: catalog.images.first,
      plantExchangeType: catalog.offerType.offerTypeName,
    );

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPlantPage(
          chatId: chatId,
          plantId: catalog.catalogId ?? '',
          plantOwnerName: ownerName,
          plantOwnerAvatar: ownerAvatar ?? '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            child: const FavoriteBtn(),
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
                  TitlePage(
                    title: catalog.name.toCapitalize(),
                    fontSize: AppTypo.textXl,
                  ),
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
            text: 'Envoyer un message',
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
