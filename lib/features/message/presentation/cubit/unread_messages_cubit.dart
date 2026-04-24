import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/chat_plant/domain/repository/chat_plant_repository.dart';
import 'package:plant_match_v2/features/message/presentation/cubit/unread_messages_state.dart';

class UnreadMessagesCubit extends Cubit<UnreadMessagesState> {
  final ChatPlantRepository repository;
  StreamSubscription? _sub;

  UnreadMessagesCubit({required this.repository})
      : super(const UnreadMessagesInitial());

  void listen(String uid) {
    _sub?.cancel();
    _sub = repository.unreadCount(uid).listen((count) {
      if (!isClosed) {
        emit(UnreadMessagesLoaded(count));
      }
    });
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
