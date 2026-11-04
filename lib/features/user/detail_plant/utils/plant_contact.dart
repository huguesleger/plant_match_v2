import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/chat_plant/data/firebase_chat_plant.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/chat_plant_page_route.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_cubit.dart';
import 'package:plant_match_v2/features/level/utils/user_points_utils.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_state.dart';
import 'package:plant_match_v2/features/user/data/firebase_user.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/no_leaves_dialog.dart';

class PlantContact {
  static Future<void> start(
    BuildContext context, {
    required Catalog catalog,
    required Option<ProfilUser> owner,
  }) async {
    final userId = Option.fromNullable(context.read<AuthCubit>().userId)
        .filter((id) => id.isNotEmpty && id != catalog.userId)
        .filter((_) => catalog.status == CatalogStatus.published);
    await userId.match(
      () async {},
      (id) => _contact(context, catalog, owner, id),
    );
  }

  static Future<void> _contact(
    BuildContext context,
    Catalog catalog,
    Option<ProfilUser> owner,
    String userId,
  ) async {
    final chatId = _chatId(catalog, userId);
    final chatExists = await FirebaseChatPlant()
        .chatExists(chatId)
        .match((_) => false, (exists) => exists)
        .run();
    if (!context.mounted) return;
    final canContact = chatExists ||
        _hasContactCredit(context.read<ProfilCubit>().state) ||
        UserPointsUtils.hasUnlimitedContacts(
          context.read<UserPointsCubit>().currentLevel,
        );
    await (canContact
        ? _openChat(context, catalog, owner, chatId)
        : NoLeavesDialog.show(context));
  }

  static Future<void> _openChat(
    BuildContext context,
    Catalog catalog,
    Option<ProfilUser> owner,
    String chatId,
  ) async {
    final resolvedOwner = await owner
        .match<Task<Option<ProfilUser>>>(
          () => FirebaseUser().getUserUid(catalog.userId).match(
                (_) => const None(),
                (user) => Some(user),
              ),
          (found) => Task.of(Some(found)),
        )
        .run();
    if (!context.mounted) return;
    resolvedOwner.match(
      () {},
      (plantOwner) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatPlantPageRoute(
            chatId: chatId,
            plantId: catalog.catalogId.getOrElse(() => ''),
            plantOwnerName: _ownerName(plantOwner),
            plantOwnerAvatar: plantOwner.profilImg.trim(),
            otherUserId: catalog.userId,
          ),
        ),
      ),
    );
  }

  static String _chatId(Catalog catalog, String userId) {
    final ids = [userId, catalog.userId]..sort();
    return '${catalog.catalogId.getOrElse(() => '')}_${ids[0]}_${ids[1]}';
  }

  static String _ownerName(ProfilUser owner) => owner.userName
      .alt(() => Some(owner.firstName))
      .filter((name) => name.trim().isNotEmpty)
      .getOrElse(() => t.user.detail_plant.owner_placeholder);

  static bool _hasContactCredit(ProfilState state) => switch (state) {
        ProfilLoaded(:final profilUser) => profilUser.leaves > 0,
        ProfilInitial() ||
        ProfilLoading() ||
        ProfilError() ||
        ProfilImageUploading() =>
          false,
      };
}
