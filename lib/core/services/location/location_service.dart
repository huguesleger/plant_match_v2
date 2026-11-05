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
            throw Exception('Service de localisation désactivé');
          }

          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
              throw Exception('Permission de localisation refusée');
            }
          }

          if (permission == LocationPermission.deniedForever) {
            throw Exception(
                'Permission de localisation refusée définitivement');
          }

          return Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(timeLimit: _timeLimit),
          ).catchError(
            (_) async => Option.fromNullable(
              await Geolocator.getLastKnownPosition(),
            ).getOrElse(() => throw Exception('Délai de localisation dépassé')),
          );
        },
        (error, stackTrace) => LocationFailure(error.toString()),
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
            throw Exception('Aucune adresse trouvée');
          }
          return placemarks.first;
        },
        (error, stackTrace) => LocationFailure(error.toString()),
      );
}
