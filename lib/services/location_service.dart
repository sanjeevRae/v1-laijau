import 'dart:async';
import 'dart:developer' as developer;
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  StreamSubscription<Position>? _positionStream;
  LatLng? _currentLocation;
  
  LatLng? get currentLocation => _currentLocation;

  Future<bool> checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<LatLng?> getCurrentLocation() async {
    try {
      final hasPermission = await checkPermissions();
      if (!hasPermission) {
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentLocation = LatLng(position.latitude, position.longitude);
      return _currentLocation;
    } catch (e) {
      developer.log('Error getting current location', error: e, name: 'LocationService');
      return null;
    }
  }

  Stream<LatLng> startLocationTracking() {
    final streamController = StreamController<LatLng>();

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).listen(
      (Position position) {
        _currentLocation = LatLng(position.latitude, position.longitude);
        streamController.add(_currentLocation!);
      },
      onError: (error) {
        developer.log('Location tracking error', error: error, name: 'LocationService');
        streamController.addError(error);
      },
    );

    return streamController.stream;
  }

  void stopLocationTracking() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  double calculateDistance(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }
  
  double calculateBearing(LatLng start, LatLng end) {
    return Geolocator.bearingBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }
}
