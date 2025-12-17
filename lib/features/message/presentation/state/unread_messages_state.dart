sealed class UnreadMessagesState {}

class UnreadMessagesInitial extends UnreadMessagesState {}

class UnreadMessagesLoaded extends UnreadMessagesState {
  final int count;

  UnreadMessagesLoaded(this.count);
}
