import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Position? currentPosition;
late bool servicePermission;
late LocationPermission permission;

String currentAddress = '';
String currentCountry = '';

Future<Position> getCurrentLocation() async {
  servicePermission = await Geolocator.isLocationServiceEnabled();
  if (!servicePermission) {
    throw Exception('Service de localisation désactivé');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low, distanceFilter: 10),
      );
    }
  }
  return await Geolocator.getCurrentPosition();
}

getCurrentAddress() async {
  try {
    List<Placemark> p = await placemarkFromCoordinates(
        currentPosition!.latitude, currentPosition!.longitude);

    Placemark place = p[0];
    currentAddress = "${place.locality}";
    currentCountry = "${place.country}";
  } catch (e) {
    throw Exception('Erreur de localisation');
  }
}
