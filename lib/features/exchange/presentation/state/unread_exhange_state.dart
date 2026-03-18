abstract class UnreadExchangesState {
  const UnreadExchangesState();
}

class UnreadExchangesInitial extends UnreadExchangesState {
  const UnreadExchangesInitial();
}

class UnreadExchangesLoaded extends UnreadExchangesState {
  final int count;

  const UnreadExchangesLoaded(this.count);
}
