import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';

abstract class LocationService {
  /// Récupère la position actuelle de l'utilisateur
  TaskEither<Failure, Position> getCurrentPosition();

  /// Récupère l'adresse à partir d'une position
  TaskEither<Failure, Placemark> getPlacemarkFromPosition(Position position);
}

class LocationServiceImpl implements LocationService {
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
            throw Exception('Permission de localisation refusée définitivement');
          }

          return await Geolocator.getCurrentPosition();
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
