import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/home_highlight/domain/entities/active_deal.dart';
import 'package:plant_match_v2/features/home_highlight/domain/entities/highlight_profile.dart';
import 'package:plant_match_v2/features/home_highlight/domain/entities/home_highlight.dart';

class HomeHighlightState {
  final Option<List<ActiveDeal>> exchanges;
  final Option<List<ActiveDeal>> donations;
  final Option<HighlightProfile> profile;

  const HomeHighlightState({
    required this.exchanges,
    required this.donations,
    required this.profile,
  });

  const HomeHighlightState.initial()
      : exchanges = const None(),
        donations = const None(),
        profile = const None();

  Option<HomeHighlight> get highlight => profile.flatMap(
        (profile) => exchanges.flatMap(
          (exchanges) => donations.map(
            (donations) =>
                HomeHighlight.select(profile, [...exchanges, ...donations]),
          ),
        ),
      );

  HomeHighlightState copyWith({
    Option<List<ActiveDeal>> exchanges = const None(),
    Option<List<ActiveDeal>> donations = const None(),
    Option<HighlightProfile> profile = const None(),
  }) =>
      HomeHighlightState(
        exchanges: exchanges.alt(() => this.exchanges),
        donations: donations.alt(() => this.donations),
        profile: profile.alt(() => this.profile),
      );
}
