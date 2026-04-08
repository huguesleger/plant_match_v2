import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/catalog/domain/repository/catalog_repository.dart';
import 'package:plant_match_v2/features/user/domain/entities/catalog_filter.dart';
import 'package:plant_match_v2/features/user/domain/entities/user.dart';
import 'package:plant_match_v2/features/user/domain/repository/user_repository.dart';
import 'package:plant_match_v2/features/user/presentation/cubit/user_state.dart';
import 'package:plant_match_v2/features/exchange/domain/repository/exchange_repository.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/user_points/domain/repository/user_points_repository.dart';

class UserCubit extends Cubit<UserState> {
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

    userRepository
        .getUserUid(uid)
        .flatMap((user) => catalogRepository
            .getCatalogsByUserId(user.uid)
            .map((catalogs) => (user, catalogs)))
        .flatMap((data) {
          final (user, catalogs) = data;
          return userPointsRepository.getPoints(user.uid).map((userPoints) {
            return (user, catalogs, userPoints.level);
          }).orElse((failure) {
            // En cas d'erreur, on utilise le niveau par défaut 1
            return TaskEither.right((user, catalogs, 1));
          });
        })
        .flatMap((data) {
          final (user, catalogs, level) = data;
          return exchangeRepository.getCompletedExchanges(user.uid).map((exchanges) {
            final completedCount = exchanges
                .where((e) => e.status == ExchangeStatus.completed)
                .length;
            return (user, catalogs, level, completedCount);
          });
        })
        .map((data) {
          final (user, catalogs, level, exchangeCount) = data;
          return User(
            user: user,
            userCatalogs: {user.uid: catalogs},
            level: level,
            exchangeCount: exchangeCount,
            selectedFilter: CatalogFilter.all,
          );
        })
        .match(
          (failure) => UserError(failure.message),
          (userData) => UserLoaded(data: userData),
        )
        .map((s) {
          if (!isClosed) {
            emit(s);
          }
        })
        .run();
  }

  void updateFilter(CatalogFilter filter) {
    final currentState = state;
    if (currentState is UserLoaded) {
      final updated = currentState.data.copyWith(selectedFilter: filter);
      emit(UserLoaded(data: updated));
    }
  }
}
