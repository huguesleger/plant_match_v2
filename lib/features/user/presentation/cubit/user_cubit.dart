import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/catolog/domain/repository/catalog_repository.dart';
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
  }) : super(UserInitial());

  Future<void> fetchUser(String uid) async {
    emit(UserLoading());

    await userRepository
        .getUserUid(uid)
        .flatMap((user) => TaskEither.tryCatch(
              () async {
                final catalogs =
                    await catalogRepository.getCatalogsByUserId(user.uid);
                return (user, catalogs);
              },
              (error, stackTrace) => FirebaseFailure(
                  'Erreur lors du chargement des catalogues : $error'),
            ))
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
          return TaskEither.tryCatch(
            () async {
              // On récupère le premier élément du stream (liste des échanges complétés)
              final exchanges = await exchangeRepository
                  .getCompletedExchanges(user.uid)
                  .first;
              final completedCount = exchanges
                  .where((e) => e.status == ExchangeStatus.completed)
                  .length;
              return (user, catalogs, level, completedCount);
            },
            (error, stackTrace) =>
                FirebaseFailure('Erreur chargement échanges : $error'),
          );
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
        .run()
        .then((result) => result.match(
              (failure) => emit(UserError(failure.message)),
              (userData) => emit(UserLoaded(data: userData)),
            ));
  }

  void updateFilter(CatalogFilter filter) {
    if (state is UserLoaded) {
      final s = state as UserLoaded;
      final updated = s.data.copyWith(selectedFilter: filter);
      emit(UserLoaded(data: updated));
    }
  }
}
