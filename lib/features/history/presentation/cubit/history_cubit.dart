import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';
import 'package:plant_match_v2/features/donation/domain/repository/donation_repository.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/exchange/domain/repository/exchange_repository.dart';
import 'package:plant_match_v2/features/history/presentation/cubit/history_state.dart';
import 'package:plant_match_v2/features/history/widgets/history_item.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final ExchangeRepository exchangeRepository;
  final DonationRepository donationRepository;
  final String userId;

  List<Exchange> _exchanges = [];
  List<Donation> _donations = [];
  HistoryStatusFilter _currentFilter = HistoryStatusFilter.all;

  HistoryCubit({
    required this.exchangeRepository,
    required this.donationRepository,
    required this.userId,
  }) : super(const HistoryInitial());

  void load({HistoryStatusFilter filter = HistoryStatusFilter.all}) {
    _currentFilter = filter;
    emit(const HistoryLoading());

    exchangeRepository.getCompletedExchanges(userId).flatMap((exchanges) {
      return donationRepository.getCompletedDonations(userId).map((donations) {
        return (exchanges, donations);
      });
    }).match(
      (failure) {
        if (!isClosed) emit(HistoryError(failure.message));
      },
      (data) {
        if (isClosed) return;
        _exchanges = data.$1;
        _donations = data.$2;
        _emitLoaded();
      },
    ).run();
  }

  void _emitLoaded() {
    if (isClosed) return;

    final exchangeItems = _exchanges.map(HistoryItem.fromExchange).toList();
    final donationItems = _donations.map(HistoryItem.fromDonation).toList();

    final all = [...exchangeItems, ...donationItems]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final filtered = _filterItems(all, _currentFilter);

    emit(HistoryLoaded(
      items: filtered,
      currentFilter: _currentFilter,
    ));
  }

  List<HistoryItem> _filterItems(
    List<HistoryItem> items,
    HistoryStatusFilter filter,
  ) {
    return switch (filter) {
      HistoryStatusFilter.all => items,
      HistoryStatusFilter.accepted =>
        items.where((i) => i.rawStatus == 'accepted').toList(),
      HistoryStatusFilter.completed =>
        items.where((i) => i.rawStatus == 'completed').toList(),
      HistoryStatusFilter.rejected =>
        items.where((i) => i.rawStatus == 'rejected').toList(),
    };
  }
}
