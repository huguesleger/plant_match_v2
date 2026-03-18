sealed class UnreadMessagesState {
  const UnreadMessagesState();
}

class UnreadMessagesInitial extends UnreadMessagesState {
  const UnreadMessagesInitial();
}

class UnreadMessagesLoaded extends UnreadMessagesState {
  final int count;

  const UnreadMessagesLoaded(this.count);
}
