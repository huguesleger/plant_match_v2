import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/home_highlight/domain/entities/active_deal.dart';

extension ExchangeToActiveDeal on Exchange {
  Option<ActiveDeal> toActiveDeal() => _exchangeStage(status).map(
        (stage) => ActiveDeal(
          chatId: chatId,
          plantId: targetPlantId,
          ownerId: ownerId,
          requestedBy: requestedBy,
          stage: stage,
          offer: ExchangeOffer(
            offeredPlantName: offeredPlantName,
            targetPlantName: targetPlantName,
          ),
          createdAt: createdAt,
        ),
      );

  static Option<DealStage> _exchangeStage(ExchangeStatus status) =>
      switch (status) {
        ExchangeStatus.pending => const Some(DealProposed()),
        ExchangeStatus.accepted => const Some(DealAccepted()),
        ExchangeStatus.waitingValidation =>
          const Some(DealAwaitingValidation()),
        ExchangeStatus.rejected || ExchangeStatus.completed => const None(),
      };
}

extension DonationToActiveDeal on Donation {
  Option<ActiveDeal> toActiveDeal() => _donationStage(status).map(
        (stage) => ActiveDeal(
          chatId: chatId,
          plantId: plantId,
          ownerId: ownerId,
          requestedBy: requestedBy,
          stage: stage,
          offer: DonationOffer(plantName: plantName),
          createdAt: createdAt,
        ),
      );

  static Option<DealStage> _donationStage(DonationStatus status) =>
      switch (status) {
        DonationStatus.pending => const Some(DealProposed()),
        DonationStatus.accepted => const Some(DealAccepted()),
        DonationStatus.waitingValidation =>
          const Some(DealAwaitingValidation()),
        DonationStatus.rejected || DonationStatus.completed => const None(),
      };
}
