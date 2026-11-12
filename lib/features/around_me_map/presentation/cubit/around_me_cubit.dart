import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geocoding/geocoding.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/around_me_map/domain/repository/around_me_repository.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_state.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/domain/repository/catalog_repository.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/profil/domain/repository/profil_repository.dart';

import 'package:plant_match_v2/core/services/location/location_service.dart';

class AroundMeCubit extends Cubit<AroundMeState> {
  final AroundMeRepository aroundMeRepository;
  final ProfilRepository profilRepository;
  final CatalogRepository catalogRepository;
  final LocationService locationService;

  AroundMeCubit({
    required this.aroundMeRepository,
    required this.profilRepository,
    required this.catalogRepository,
    required this.locationService,
  }) : super(const AroundMeInitial());

  static const int _catalogLimit = 300;

  void getAllUserProfiles(String uid) {
    emit(const AroundMeLoading());
    _loadAll(uid)
        .match((failure) => AroundMeError(failure), (state) => state)
        .map(emit)
        .run();
  }

  void reset() => emit(const AroundMeInitial());

  Future<void> refresh(String uid) => _loadAll(uid)
      .match(
        (failure) => switch (state) {
          AroundMeLoaded() => state,
          AroundMeInitial() ||
          AroundMeLoading() ||
          AroundMeError() =>
            AroundMeError(failure),
        },
        (loaded) => loaded,
      )
      .map(emit)
      .run();

  TaskEither<Failure, AroundMeState> _loadAll(String uid) => profilRepository
      .getProfilUser(uid)
      .flatMap(
        (option) => option.match(
          () => TaskEither<Failure, ProfilUser>.left(
            const SessionExpiredFailure('No current user'),
          ),
          TaskEither.right,
        ),
      )
      .flatMap(_loadAround);

  Future<void> updateUserLocation(ProfilUser user) {
    final previous = state;
    emit(
      switch (previous) {
        AroundMeLoaded() =>
          previous.copyWith(
            locating: const Some(true),
            locationError: const Some(None()),
          ),
        AroundMeInitial() ||
        AroundMeLoading() ||
        AroundMeError() =>
          const AroundMeLoading(),
      },
    );

    return locationService
        .getCurrentPosition()
        .flatMap(
          (position) => locationService
              .getPlacemarkFromPosition(position)
              .map<Option<Placemark>>(Some.new)
              .alt(() => TaskEither.right(const None()))
              .map((placemark) => (position, placemark)),
        )
        .flatMap((data) {
          final (position, placemark) = data;
          final updatedUser = user.copyWith(
            newLocalisation: Some(placemark
                .flatMap((p) => Option.fromNullable(p.locality))
                .getOrElse(() => user.localisation)),
            newCountry: Some(placemark
                .flatMap((p) => Option.fromNullable(p.country))
                .getOrElse(() => user.country)),
            newZipCode: Some(placemark
                .flatMap((p) => Option.fromNullable(p.postalCode))
                .getOrElse(() => user.zipCode)),
            newLatitude: Some(Some(position.latitude)),
            newLongitude: Some(Some(position.longitude)),
          );
          return aroundMeRepository
              .updateUserLocation(updatedUser)
              .map((_) => updatedUser);
        })
        .flatMap(_loadAround)
        .match(
          (failure) => switch (previous) {
            AroundMeLoaded() => previous.copyWith(
                locating: const Some(false),
                locationError: Some(Some(failure)),
              ),
            AroundMeInitial() ||
            AroundMeLoading() ||
            AroundMeError() =>
              AroundMeError(failure),
          },
          (state) => state,
        )
        .map(emit)
        .run();
  }

  TaskEither<Failure, AroundMeState> _loadAround(ProfilUser currentUser) =>
      catalogRepository.getPublishedCatalogs(limit: _catalogLimit).flatMap(
            (published) => aroundMeRepository
                .getUsersByIds(
                  published
                      .map((catalog) => catalog.userId)
                      .where((owner) => owner != currentUser.uid)
                      .toSet(),
                )
                .flatMap(
                  (owners) => catalogRepository
                      .getCatalogsByUserId(currentUser.uid)
                      .orElse((_) =>
                          TaskEither<Failure, List<Catalog>>.right(const []))
                      .map<AroundMeState>(
                        (ownCatalogs) => AroundMeLoaded(
                          currentUser: currentUser,
                          users: [currentUser, ...owners],
                          userCatalogs: {
                            for (final owner in owners)
                              owner.uid: published
                                  .where((c) => c.userId == owner.uid)
                                  .toList(),
                            currentUser.uid: ownCatalogs,
                          },
                        ),
                      ),
                ),
          );
}
