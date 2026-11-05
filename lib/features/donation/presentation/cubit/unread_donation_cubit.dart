import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/donation/domain/repository/donation_repository.dart';
import 'package:plant_match_v2/features/donation/presentation/state/unread_donation_state.dart';

class UnreadDonationsCubit extends Cubit<UnreadDonationsState> {
  final DonationRepository repository;
  Option<StreamSubscription<int>> _sub = const None();

  UnreadDonationsCubit({required this.repository})
      : super(const UnreadDonationsInitial());

  void listen(String uid) {
    _sub.map((sub) => sub.cancel());
    _sub = Some(repository.unreadDonationCount(uid).listen((count) {
      if (!isClosed) {
        emit(UnreadDonationsLoaded(count));
      }
    }));
  }

  @override
  Future<void> close() {
    _sub.map((sub) => sub.cancel());
    return super.close();
  }
}
