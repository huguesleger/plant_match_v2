import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';
import 'package:plant_match_v2/features/donation/domain/repository/donation_repository.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/exchange/domain/repository/exchange_repository.dart';
import 'package:plant_match_v2/features/history/presentation/cubit/history_state.dart';
import 'package:plant_match_v2/features/history/presentation/widgets/history_item.dart';

class HistoryCubit extends SafeCubit<HistoryState> {
  final ExchangeRepository exchangeRepository;
  final DonationRepository donationRepository;
  final String userId;

  HistoryStatusFilter _currentFilter = HistoryStatusFilter.all;

  HistoryCubit({
    required this.exchangeRepository,
    required this.donationRepository,
    required this.userId,
  }) : super(const HistoryInitial());

  void load({HistoryStatusFilter filter = HistoryStatusFilter.all}) {
    _currentFilter = filter;
    emit(const HistoryLoading());
    _fetch().map(emit).run();
  }

  Future<void> refresh() => _fetch()
      .map(
        (fetched) =>
            fetched is HistoryError && state is HistoryLoaded ? state : fetched,
      )
      .map(emit)
      .run();

  Task<HistoryState> _fetch() => exchangeRepository
      .getCompletedExchanges(userId)
      .flatMap(
        (exchanges) => donationRepository
            .getCompletedDonations(userId)
            .map((donations) => (exchanges, donations)),
      )
      .match(
        (failure) => HistoryError(failure),
        (data) => _loaded(data.$1, data.$2),
      );

  HistoryLoaded _loaded(List<Exchange> exchanges, List<Donation> donations) {
    final exchangeItems = exchanges.map(HistoryItem.fromExchange).toList();
    final donationItems = donations.map(HistoryItem.fromDonation).toList();

    final all = [...exchangeItems, ...donationItems]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return HistoryLoaded(
      items: _filterItems(all, _currentFilter),
      currentFilter: _currentFilter,
    );
  }

  List<HistoryItem> _filterItems(
    List<HistoryItem> items,
    HistoryStatusFilter filter,
  ) {
    return switch (filter) {
      HistoryStatusFilter.all => items,
      HistoryStatusFilter.accepted => items
          .where((i) => i.rawStatus == ExchangeStatus.accepted.name)
          .toList(),
      HistoryStatusFilter.completed => items
          .where((i) => i.rawStatus == ExchangeStatus.completed.name)
          .toList(),
      HistoryStatusFilter.rejected => items
          .where((i) => i.rawStatus == ExchangeStatus.rejected.name)
          .toList(),
    };
  }
}
