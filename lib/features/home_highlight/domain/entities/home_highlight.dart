import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/home_highlight/domain/entities/active_deal.dart';
import 'package:plant_match_v2/features/home_highlight/domain/entities/highlight_profile.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

sealed class HomeHighlight {
  const HomeHighlight();

  static HomeHighlight select(
    HighlightProfile profile,
    List<ActiveDeal> deals,
  ) =>
      <HomeHighlight>[
        ..._dealHighlights(profile, deals),
        if (!profile.hasPlants) const PublishFirstPlant(),
        if (profile.isOutOfLeaves) EarnLeaves(profile.referralCode),
      ].firstOption.getOrElse(() => const FindYourPlant());

  static List<DealHighlight> _dealHighlights(
    HighlightProfile profile,
    List<ActiveDeal> deals,
  ) =>
      deals
          .expand((deal) => _dealHighlight(profile, deal).match(
                () => const <DealHighlight>[],
                (highlight) => [highlight],
              ))
          .toList()
        ..sort((a, b) => a.priority != b.priority
            ? a.priority.compareTo(b.priority)
            : a.deal.createdAt.compareTo(b.deal.createdAt));

  static Option<DealHighlight> _dealHighlight(
    HighlightProfile profile,
    ActiveDeal deal,
  ) =>
      _dealHighlightFor(
        DealParty(
          deal.otherUserId(profile.uid),
          profile.userOf(deal.otherUserId(profile.uid)),
        ),
        deal,
        isOwner: deal.isOwnedBy(profile.uid),
      );

  static Option<DealHighlight> _dealHighlightFor(
    DealParty other,
    ActiveDeal deal, {
    required bool isOwner,
  }) =>
      switch ((deal.stage, isOwner)) {
        (DealProposed(), true) => Some(AnswerProposal(deal, other)),
        (DealAwaitingValidation(), false) =>
          Some(ValidateHandover(deal, other)),
        (DealAccepted(), true) => Some(GenerateHandoverCode(deal, other)),
        (DealProposed(), false) ||
        (DealAccepted(), false) ||
        (DealAwaitingValidation(), true) =>
          const None(),
      };
}

class DealParty {
  final String userId;
  final Option<ProfilUser> user;

  const DealParty(this.userId, this.user);
}

sealed class DealHighlight extends HomeHighlight {
  final ActiveDeal deal;
  final DealParty other;

  const DealHighlight(this.deal, this.other);

  int get priority => switch (this) {
        AnswerProposal() => 0,
        ValidateHandover() => 1,
        GenerateHandoverCode() => 2,
      };
}

class AnswerProposal extends DealHighlight {
  const AnswerProposal(super.deal, super.other);
}

class ValidateHandover extends DealHighlight {
  const ValidateHandover(super.deal, super.other);
}

class GenerateHandoverCode extends DealHighlight {
  const GenerateHandoverCode(super.deal, super.other);
}

class PublishFirstPlant extends HomeHighlight {
  const PublishFirstPlant();
}

class EarnLeaves extends HomeHighlight {
  final String referralCode;

  const EarnLeaves(this.referralCode);
}

class FindYourPlant extends HomeHighlight {
  const FindYourPlant();
}
