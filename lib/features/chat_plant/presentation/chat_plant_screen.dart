import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/avatar/avatar.dart';
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

  void _handleExchangeState(
      BuildContext context, Exchange ex, ExchangeState state, String userId) {
    final cubit = context.read<ExchangeCubit>();
    if (userId == ex.ownerId && !ex.seenByOwner) {
      cubit.markSeenByOwner(ex.id);
    }
    if (userId == ex.requestedBy &&
        !ex.seenByRequester &&
        state is! ExchangePending) {
      cubit.markSeenByRequester(ex.id);
    }
  }

  void _handleDonationState(
      BuildContext context, Donation don, DonationState state, String userId) {
    final cubit = context.read<DonationCubit>();
    if (userId == don.ownerId && !don.seenByOwner) {
      cubit.markSeenByOwner(don.id);
    }
    if (userId == don.requestedBy &&
        !don.seenByRequester &&
        state is! DonationPending) {
      cubit.markSeenByRequester(don.id);
    }
  }

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
            final Option<Exchange> option = switch (state) {
              ExchangePending(:final exchange) ||
              ExchangeAccepted(:final exchange) ||
              ExchangeWaitingValidation(:final exchange) ||
              ExchangeRejected(:final exchange) ||
              ExchangeCompleted(:final exchange) =>
                Some(exchange),
              ExchangeInitial() ||
              ExchangeLoading() ||
              ExchangePickingPlant() ||
              ExchangeConfirming() ||
              ExchangeSuccess() ||
              ExchangeError() =>
                const None(),
            };

            option.match(
              () {},
              (ex) => _handleExchangeState(context, ex, state, userId),
            );
          },
        ),
        BlocListener<DonationCubit, DonationState>(
          listener: (context, state) {
            final Option<Donation> option = switch (state) {
              DonationPending(:final donation) ||
              DonationAccepted(:final donation) ||
              DonationWaitingValidation(:final donation) ||
              DonationRejected(:final donation) ||
              DonationCompleted(:final donation) =>
                Some(donation),
              DonationInitial() ||
              DonationLoading() ||
              DonationError() =>
                const None(),
            };

            option.match(
              () {},
              (don) => _handleDonationState(context, don, state, userId),
            );
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
                  Avatar(
                    radius: 28,
                    imageUrl: plantOwnerAvatar,
                    name: plantOwnerName,
                    imgSizeAvatar: 55,
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
