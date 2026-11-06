import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';

abstract class LocationService {
  TaskEither<Failure, Position> getCurrentPosition();

  TaskEither<Failure, Placemark> getPlacemarkFromPosition(Position position);
}

class LocationServiceImpl implements LocationService {
  static const Duration _timeLimit = Duration(seconds: 15);

  @override
  TaskEither<Failure, Position> getCurrentPosition() => TaskEither.tryCatch(
        () async {
          bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (!serviceEnabled) {
            throw const LocationServiceDisabledFailure('Location service disabled');
          }

          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
              throw const LocationPermissionDeniedFailure('Location permission denied');
            }
          }

          if (permission == LocationPermission.deniedForever) {
            throw const LocationPermissionDeniedFailure(
                'Location permission denied forever');
          }

          return Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(timeLimit: _timeLimit),
          ).catchError(
            (_) async => Option.fromNullable(
              await Geolocator.getLastKnownPosition(),
            ).getOrElse(() => throw const LocationUnavailableFailure('Location timeout')),
          );
        },
        (error, _) => switch (error) {
          LocationFailure() => error,
          Object() => LocationUnavailableFailure('$error'),
        },
      );

  @override
  TaskEither<Failure, Placemark> getPlacemarkFromPosition(Position position) =>
      TaskEither.tryCatch(
        () async {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          if (placemarks.isEmpty) {
            throw const LocationUnavailableFailure('No placemark found');
          }
          return placemarks.first;
        },
        (error, _) => switch (error) {
          LocationFailure() => error,
          Object() => LocationUnavailableFailure('$error'),
        },
      );
}
