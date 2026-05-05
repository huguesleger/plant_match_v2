import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/cubit/chat_plant_cubit.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/state/chat_plant_state.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/chat_plant_menu.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/chat_plant_view.dart';
import 'package:plant_match_v2/features/donation/presentation/cubit/donation_cubit.dart';
import 'package:plant_match_v2/features/donation/presentation/state/donation_state.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_cubit.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/exchange_state.dart';

class ChatPlantScreen extends StatelessWidget {
  const ChatPlantScreen({
    super.key,
    required this.chatId,
    required this.plantId,
    required this.plantOwnerName,
    required this.plantOwnerAvatar,
  });

  final String chatId;
  final String plantId;
  final String plantOwnerName;
  final String plantOwnerAvatar;

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthCubit>().userId ?? '';
    final catalogRepo = FirebaseCatalogRepository();

    return MultiBlocListener(
      listeners: [
        BlocListener<ChatPlantCubit, ChatPlantState>(
          listener: (context, state) {
            if (state is ChatPlantLoaded) {
              context.read<ChatPlantCubit>().markMessagesAsRead(
                    chatId: chatId,
                    currentUserId: userId,
                  );
            }
          },
        ),
        BlocListener<ExchangeCubit, ExchangeState>(
          listener: (context, state) {
            final ex = switch (state) {
              ExchangePending(:final exchange) => exchange,
              ExchangeAccepted(:final exchange) => exchange,
              ExchangeWaitingValidation(:final exchange) => exchange,
              ExchangeRejected(:final exchange) => exchange,
              ExchangeCompleted(:final exchange) => exchange,
              ExchangeInitial() ||
              ExchangeLoading() ||
              ExchangePickingPlant() ||
              ExchangeConfirming() ||
              ExchangeSuccess() ||
              ExchangeError() =>
                null,
            };
            if (ex == null) return;

            final cubit = context.read<ExchangeCubit>();
            if (userId == ex.ownerId && !ex.seenByOwner) {
              cubit.markSeenByOwner(ex.id);
            }
            if (userId == ex.requestedBy &&
                !ex.seenByRequester &&
                state is! ExchangePending) {
              cubit.markSeenByRequester(ex.id);
            }
          },
        ),
        BlocListener<DonationCubit, DonationState>(
          listener: (context, state) {
            final don = switch (state) {
              DonationPending(:final donation) => donation,
              DonationAccepted(:final donation) => donation,
              DonationWaitingValidation(:final donation) => donation,
              DonationRejected(:final donation) => donation,
              DonationCompleted(:final donation) => donation,
              DonationInitial() || DonationLoading() || DonationError() => null,
            };
            if (don == null) return;

            final cubit = context.read<DonationCubit>();
            if (userId == don.ownerId && !don.seenByOwner) {
              cubit.markSeenByOwner(don.id);
            }
            if (userId == don.requestedBy &&
                !don.seenByRequester &&
                state is! DonationPending) {
              cubit.markSeenByRequester(don.id);
            }
          },
        ),
      ],
      child: FutureBuilder<Catalog?>(
        future: catalogRepo
            .getCatalogById(plantId)
            .map((opt) => opt.toNullable())
            .getOrElse((_) => null)
            .run(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final plant = snapshot.data!;

          return Scaffold(
            appBar: AppBarTemplate(
              preferredHeight: 85,
              backgroundColor: AppColors.white,
              surfaceTintColor: Colors.white,
              onPressed: () => Navigator.pop(context),
              styleIconButton: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: const BorderSide(color: AppColors.greyLight),
              ),
              titleWidget: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.greyLight,
                    backgroundImage: plantOwnerAvatar.isNotEmpty &&
                            plantOwnerAvatar != 'null'
                        ? NetworkImage(plantOwnerAvatar)
                        : null,
                    child:
                        plantOwnerAvatar.isEmpty || plantOwnerAvatar == 'null'
                            ? Text(
                                plantOwnerName[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    plantOwnerName,
                    style: InterTextStyle.inter(
                      AppTypo.textM,
                    ),
                  ),
                ],
              ),
              actions: [
                ChatPlantMenu(chatId: chatId, plantOwnerId: plant.userId),
              ],
            ),
            body: BlocBuilder<ChatPlantCubit, ChatPlantState>(
              builder: (context, state) => switch (state) {
                ChatPlantInitial() || ChatPlantLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ChatPlantError s => ErrorPage(
                    errorMessage: s.message,
                    onRetry: () => context.read<ChatPlantCubit>().subscribe(
                          chatId: chatId,
                          currentUserId: userId,
                        ),
                  ),
                ChatPlantBlocked() => ChatPlantView(
                    chatId: chatId,
                    plantId: plantId,
                    plantName: plant.name,
                    plantImage:
                        plant.images.isNotEmpty ? plant.images.first : '',
                    plantOwnerId: plant.userId,
                    plantOwnerName: plantOwnerName,
                    plantOfferType: plant.offerType,
                    messages: const [],
                    isBlocked: true,
                  ),
                ChatPlantLoaded s => ChatPlantView(
                    chatId: chatId,
                    plantId: plantId,
                    plantName: plant.name,
                    plantImage:
                        plant.images.isNotEmpty ? plant.images.first : '',
                    plantOwnerId: plant.userId,
                    plantOwnerName: plantOwnerName,
                    plantOfferType: plant.offerType,
                    messages: s.messages,
                    isBlocked: s.isBlocked,
                  ),
              },

            ),
          );
        },
      ),
    );
  }
}
