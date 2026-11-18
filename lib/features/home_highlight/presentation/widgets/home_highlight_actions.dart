import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/add_plant_wizard_page_route.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/chat_plant_page_route.dart';
import 'package:plant_match_v2/features/home_highlight/domain/entities/home_highlight.dart';
import 'package:plant_match_v2/features/home_highlight/presentation/widgets/highlight_content.dart';
import 'package:plant_match_v2/features/recommendation/presentation/recommendation_page_route.dart';
import 'package:share_plus/share_plus.dart';

class HomeHighlightActions {
  const HomeHighlightActions._();

  static Future<void> open(BuildContext context, HomeHighlight highlight) =>
      switch (highlight) {
        final DealHighlight deal => _push(context, _chatOf(deal)),
        PublishFirstPlant() => _push(
            context,
            AddPlantWizardPageRoute(
              catalog: Catalog.empty(
                context.read<AuthCubit>().userId.getOrElse(() => ''),
              ),
            ),
          ),
        EarnLeaves(:final referralCode) => Share.share(
            t.homeHighlight.earn_leaves.share(code: referralCode),
          ),
        FindYourPlant() => _push(context, const RecommendationPageRoute()),
      };

  static Widget _chatOf(DealHighlight highlight) => ChatPlantPageRoute(
        chatId: highlight.deal.chatId,
        plantId: highlight.deal.plantId,
        plantOwnerName: highlight.otherName,
        plantOwnerAvatar: highlight.other.user
            .map((user) => user.profilImg.trim())
            .getOrElse(() => ''),
        otherUserId: highlight.other.userId,
      );

  static Future<void> _push(BuildContext context, Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));
}
