import 'package:flutter/widgets.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/home_highlight/domain/entities/active_deal.dart';
import 'package:plant_match_v2/features/home_highlight/domain/entities/home_highlight.dart';

sealed class HighlightTone {
  const HighlightTone();
}

class UrgentTone extends HighlightTone {
  const UrgentTone();
}

class GentleTone extends HighlightTone {
  const GentleTone();
}

class HighlightContent {
  final IconData icon;
  final String title;
  final String subtitle;
  final String cta;
  final HighlightTone tone;

  const HighlightContent({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.cta,
    required this.tone,
  });
}

extension HomeHighlightContent on HomeHighlight {
  HighlightContent get content => switch (this) {
        final AnswerProposal highlight => HighlightContent(
            icon: switch (highlight.deal.offer) {
              ExchangeOffer() => LucideIcons.arrow_left_right,
              DonationOffer() => LucideIcons.gift,
            },
            title: t.homeHighlight.answer_proposal.title,
            subtitle: _proposalText(highlight.deal.offer, highlight.otherName),
            cta: t.homeHighlight.answer_proposal.cta,
            tone: const UrgentTone(),
          ),
        final ValidateHandover highlight => HighlightContent(
            icon: LucideIcons.circle_check,
            title: t.homeHighlight.validate_handover.title,
            subtitle: t.homeHighlight.validate_handover.subtitle(
                name: highlight.otherName,
                plant: highlight.deal.ownerPlantName),
            cta: t.homeHighlight.validate_handover.cta,
            tone: const UrgentTone(),
          ),
        final GenerateHandoverCode highlight => HighlightContent(
            icon: LucideIcons.qr_code,
            title: t.homeHighlight.generate_code.title,
            subtitle: t.homeHighlight.generate_code.subtitle(
                name: highlight.otherName,
                plant: highlight.deal.ownerPlantName),
            cta: t.homeHighlight.generate_code.cta,
            tone: const UrgentTone(),
          ),
        PublishFirstPlant() => HighlightContent(
            icon: LucideIcons.sprout,
            title: t.homeHighlight.first_plant.title,
            subtitle: t.homeHighlight.first_plant.subtitle,
            cta: t.homeHighlight.first_plant.cta,
            tone: const GentleTone(),
          ),
        EarnLeaves() => HighlightContent(
            icon: LucideIcons.leaf,
            title: t.homeHighlight.earn_leaves.title,
            subtitle: t.homeHighlight.earn_leaves.subtitle,
            cta: t.homeHighlight.earn_leaves.cta,
            tone: const GentleTone(),
          ),
        FindYourPlant() => HighlightContent(
            icon: LucideIcons.sparkles,
            title: t.homeHighlight.find_plant.title,
            subtitle: t.homeHighlight.find_plant.subtitle,
            cta: t.homeHighlight.find_plant.cta,
            tone: const GentleTone(),
          ),
      };

  static String _proposalText(DealOffer offer, String name) => switch (offer) {
        ExchangeOffer(:final offeredPlantName, :final targetPlantName) =>
          t.homeHighlight.answer_proposal.exchange(
            name: name,
            offered: offeredPlantName,
            target: targetPlantName,
          ),
        DonationOffer(:final plantName) => t.homeHighlight.answer_proposal
            .donation(name: name, plant: plantName),
      };
}

extension DealHighlightName on DealHighlight {
  String get otherName => other.user.match(
        () => t.homeHighlight.someone,
        (user) => user.userName.getOrElse(() => user.fullName.split(' ').first),
      );
}
