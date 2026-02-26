import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';
import 'package:plant_match_v2/features/donation/domain/repository/donation_repository.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/exchange/domain/repository/exchange_repository.dart';
import 'package:plant_match_v2/features/profil/presentation/exchange_history/exchange_history_state.dart';
import 'package:plant_match_v2/features/profil/presentation/exchange_history/history_item.dart';

class ExchangeHistoryCubit extends Cubit<ExchangeHistoryState> {
  final ExchangeRepository exchangeRepository;
  final DonationRepository donationRepository;
  final String userId;

  StreamSubscription<List<Exchange>>? _exchangeSub;
  StreamSubscription<List<Donation>>? _donationSub;

  List<Exchange> _exchanges = [];
  List<Donation> _donations = [];
  HistoryStatusFilter _currentFilter = HistoryStatusFilter.all;

  ExchangeHistoryCubit({
    required this.exchangeRepository,
    required this.donationRepository,
    required this.userId,
  }) : super(ExchangeHistoryInitial());

  void load({HistoryStatusFilter filter = HistoryStatusFilter.all}) {
    _currentFilter = filter;
    emit(ExchangeHistoryLoading());

    _exchangeSub?.cancel();
    _donationSub?.cancel();

    _exchangeSub = exchangeRepository.getCompletedExchanges(userId).listen(
      (exchanges) {
        _exchanges = exchanges;
        _emitLoaded();
      },
      onError: (e) => emit(ExchangeHistoryError(e.toString())),
    );

    _donationSub = donationRepository.getCompletedDonations(userId).listen(
      (donations) {
        _donations = donations;
        _emitLoaded();
      },
      onError: (e) => emit(ExchangeHistoryError(e.toString())),
    );
  }

  void _emitLoaded() {
    final exchangeItems = _exchanges.map(HistoryItem.fromExchange).toList();
    final donationItems = _donations.map(HistoryItem.fromDonation).toList();

    final all = [...exchangeItems, ...donationItems]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final filtered = _filterItems(all, _currentFilter);

    emit(ExchangeHistoryLoaded(
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

  @override
  Future<void> close() {
    _exchangeSub?.cancel();
    _donationSub?.cancel();
    return super.close();
  }
}

// Conservé pour compatibilité, remplacé par HistoryStatusFilter
typedef ExchangeStatusFilter = HistoryStatusFilter;
