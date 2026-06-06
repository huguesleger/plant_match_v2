import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/donation/domain/repository/donation_repository.dart';
import 'package:plant_match_v2/features/donation/presentation/state/unread_donation_state.dart';

class UnreadDonationsCubit extends Cubit<UnreadDonationsState> {
  final DonationRepository repository;
  StreamSubscription? _sub;

  UnreadDonationsCubit({required this.repository})
      : super(const UnreadDonationsInitial());

  void listen(String uid) {
    _sub?.cancel();
    _sub = repository.unreadDonationCount(uid).listen((count) {
      if (!isClosed) {
        emit(UnreadDonationsLoaded(count));
      }
    });
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
