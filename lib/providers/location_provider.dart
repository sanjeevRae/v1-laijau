import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../services/location_service.dart';
import '../services/socket_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final SocketService _socketService = SocketService();
  
  LatLng? _currentLocation;
  LatLng? _pickupLocation;
  LatLng? _dropoffLocation;
  String? _pickupAddress;
  String? _dropoffAddress;
  bool _isTracking = false;
  StreamSubscription<LatLng>? _locationStream;

  LatLng? get currentLocation => _currentLocation;
  LatLng? get pickupLocation => _pickupLocation;
  LatLng? get dropoffLocation => _dropoffLocation;
  String? get pickupAddress => _pickupAddress;
  String? get dropoffAddress => _dropoffAddress;
  bool get isTracking => _isTracking;

  Future<bool> initialize() async {
    try {
      final hasPermission = await _locationService.checkPermissions();
      if (hasPermission) {
        // Don't await to avoid blocking
        getCurrentLocation().catchError((e) {
          developer.log('Failed to get location', error: e, name: 'LocationProvider');
        });
      }
      return hasPermission;
    } catch (e) {
      developer.log('Failed to initialize location', error: e, name: 'LocationProvider');
      return false;
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      _currentLocation = await _locationService.getCurrentLocation();
      notifyListeners();
    } catch (e) {
      developer.log('Error getting location', error: e, name: 'LocationProvider');
    }
  }

  Future<void> startTracking({bool emitToServer = false}) async {
    _isTracking = true;
    
    _locationStream = _locationService.startLocationTracking().listen((location) {
      _currentLocation = location;
      notifyListeners();
      
      if (emitToServer) {
        _socketService.emitLocationUpdate({
          'lat': location.latitude,
          'lng': location.longitude,
        });
      }
    });
  }

  void stopTracking() {
    _isTracking = false;
    _locationStream?.cancel();
    _locationService.stopLocationTracking();
    notifyListeners();
  }

  void setPickupLocation(LatLng location, {String? address}) {
    _pickupLocation = location;
    _pickupAddress = address;
    notifyListeners();
  }

  void setDropoffLocation(LatLng location, {String? address}) {
    _dropoffLocation = location;
    _dropoffAddress = address;
    notifyListeners();
  }

  void clearLocations() {
    _pickupLocation = null;
    _dropoffLocation = null;
    _pickupAddress = null;
    _dropoffAddress = null;
    notifyListeners();
  }
  
  double? getDistance(LatLng start, LatLng end) {
    return _locationService.calculateDistance(start, end);
  }
  
  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }
}
