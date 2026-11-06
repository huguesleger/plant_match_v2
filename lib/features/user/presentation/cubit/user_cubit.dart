import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/catalog/domain/repository/catalog_repository.dart';
import 'package:plant_match_v2/features/user/domain/entities/catalog_filter.dart';
import 'package:plant_match_v2/features/user/domain/entities/user.dart';
import 'package:plant_match_v2/features/user/domain/repository/user_repository.dart';
import 'package:plant_match_v2/features/user/presentation/cubit/user_state.dart';
import 'package:plant_match_v2/features/exchange/domain/repository/exchange_repository.dart';
import 'package:plant_match_v2/features/level/domain/repository/user_points_repository.dart';

class UserCubit extends SafeCubit<UserState> {
  final UserRepository userRepository;
  final CatalogRepository catalogRepository;
  final UserPointsRepository userPointsRepository;
  final ExchangeRepository exchangeRepository;

  UserCubit({
    required this.userRepository,
    required this.catalogRepository,
    required this.userPointsRepository,
    required this.exchangeRepository,
  }) : super(const UserInitial());

  void fetchUser(String uid) {
    emit(const UserLoading());
    _fetch(uid).map(emit).run();
  }

  Future<void> refresh(String uid) => _fetch(uid)
      .map(
        (fetched) => switch (state) {
          UserLoaded(:final data) => switch (fetched) {
              UserLoaded(data: final fresh) => UserLoaded(
                  data: fresh.copyWith(
                    selectedFilter: Some(data.selectedFilter),
                  ),
                ),
              UserInitial() || UserLoading() || UserError() => state,
            },
          UserInitial() || UserLoading() || UserError() => fetched,
        },
      )
      .map(emit)
      .run();

  Task<UserState> _fetch(String uid) => userRepository
          .getUserUid(uid)
          .flatMap((user) => catalogRepository
              .getCatalogsByUserId(user.uid)
              .map((catalogs) => (user, catalogs)))
          .flatMap((data) {
        final (user, catalogs) = data;
        return userPointsRepository
            .getPoints(user.uid)
            .map((userPoints) => (user, catalogs, userPoints.level))
            .orElse((_) => TaskEither.right((user, catalogs, 1)));
      }).flatMap((data) {
        final (user, catalogs, level) = data;
        return exchangeRepository
            .completedExchangeCount(user.uid)
            .map<Option<int>>(Some.new)
            .orElse((_) => TaskEither<Failure, Option<int>>.right(const None()))
            .map((completedCount) => (user, catalogs, level, completedCount));
      }).map((data) {
        final (user, catalogs, level, exchangeCount) = data;
        return User(
          user: user,
          userCatalogs: {user.uid: catalogs},
          level: level,
          exchangeCount: exchangeCount,
          selectedFilter: CatalogFilter.all,
        );
      }).match(
        (failure) => UserError(failure.message),
        (userData) => UserLoaded(data: userData),
      );

  void updateFilter(CatalogFilter filter) {
    final currentState = state;
    if (currentState is UserLoaded) {
      final updated = currentState.data.copyWith(selectedFilter: Some(filter));
      emit(UserLoaded(data: updated));
    }
  }
}
