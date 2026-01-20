abstract class UnreadExchangesState {}

class UnreadExchangesInitial extends UnreadExchangesState {}

class UnreadExchangesLoaded extends UnreadExchangesState {
  final int count;

  UnreadExchangesLoaded(this.count);
}
