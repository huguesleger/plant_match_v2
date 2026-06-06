sealed class UnreadDonationsState {
  const UnreadDonationsState();

  T match<T>({
    required T Function(UnreadDonationsInitial state) initial,
    required T Function(UnreadDonationsLoaded state) loaded,
  }) {
    return switch (this) {
      UnreadDonationsInitial s => initial(s),
      UnreadDonationsLoaded s => loaded(s),
    };
  }
}

class UnreadDonationsInitial extends UnreadDonationsState {
  const UnreadDonationsInitial();
}

class UnreadDonationsLoaded extends UnreadDonationsState {
  final int count;

  const UnreadDonationsLoaded(this.count);
}
