import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:plant_match_v2/features/home/domain/entities/home.dart';
import 'package:plant_match_v2/features/home/presentation/cubit/home_state.dart';
import 'package:plant_match_v2/features/home_highlight/domain/entities/highlight_profile.dart';
import 'package:plant_match_v2/features/home_highlight/domain/repositories/active_deal_repository.dart';
import 'package:plant_match_v2/features/home_highlight/presentation/cubit/home_highlight_state.dart';

class HomeHighlightCubit extends SafeCubit<HomeHighlightState> {
  final ActiveDealRepository _repository;
  List<StreamSubscription<void>> _subscriptions = const [];

  HomeHighlightCubit({required ActiveDealRepository repository})
      : _repository = repository,
        super(const HomeHighlightState.initial());

  void listen(String uid) {
    _cancelSubscriptions();
    _subscriptions = [
      _repository.watchActiveExchanges(uid).listen(
            (deals) => emit(state.copyWith(exchanges: Some(deals))),
            onError: (Object _) =>
                emit(state.copyWith(exchanges: const Some([]))),
          ),
      _repository.watchActiveDonations(uid).listen(
            (deals) => emit(state.copyWith(donations: Some(deals))),
            onError: (Object _) =>
                emit(state.copyWith(donations: const Some([]))),
          ),
    ];
  }

  void syncHome(HomeState home) => _profileOf(home)
      .map((profile) => emit(state.copyWith(profile: Some(profile))));

  Option<HighlightProfile> _profileOf(HomeState home) => switch (home) {
        HomeLoaded(:final home, :final leaves) =>
          Some(_profileFrom(home, leaves)),
        HomeLoading() || HomeError() => const None(),
      };

  HighlightProfile _profileFrom(Home home, Option<int> leaves) =>
      HighlightProfile(
        uid: home.currentUser.uid,
        leaves: leaves.getOrElse(() => home.currentUser.leaves),
        referralCode: home.currentUser.referralCode,
        hasPlants: Option.fromNullable(home.userCatalogs[home.currentUser.uid])
            .filter((catalogs) => catalogs.isNotEmpty)
            .isSome(),
        users: home.users,
      );

  Future<void> _cancelSubscriptions() => Future.wait(
        _subscriptions.map((subscription) => subscription.cancel()),
      );

  @override
  Future<void> close() {
    _cancelSubscriptions();
    return super.close();
  }
}
