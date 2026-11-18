sealed class DealStage {
  const DealStage();
}

class DealProposed extends DealStage {
  const DealProposed();
}

class DealAccepted extends DealStage {
  const DealAccepted();
}

class DealAwaitingValidation extends DealStage {
  const DealAwaitingValidation();
}

sealed class DealOffer {
  const DealOffer();
}

class ExchangeOffer extends DealOffer {
  final String offeredPlantName;
  final String targetPlantName;

  const ExchangeOffer({
    required this.offeredPlantName,
    required this.targetPlantName,
  });
}

class DonationOffer extends DealOffer {
  final String plantName;

  const DonationOffer({required this.plantName});
}

class ActiveDeal {
  final String chatId;
  final String plantId;
  final String ownerId;
  final String requestedBy;
  final DealStage stage;
  final DealOffer offer;
  final DateTime createdAt;

  const ActiveDeal({
    required this.chatId,
    required this.plantId,
    required this.ownerId,
    required this.requestedBy,
    required this.stage,
    required this.offer,
    required this.createdAt,
  });

  bool isOwnedBy(String uid) => ownerId == uid;

  String otherUserId(String uid) => isOwnedBy(uid) ? requestedBy : ownerId;

  String get ownerPlantName => switch (offer) {
        ExchangeOffer(:final targetPlantName) => targetPlantName,
        DonationOffer(:final plantName) => plantName,
      };
}
