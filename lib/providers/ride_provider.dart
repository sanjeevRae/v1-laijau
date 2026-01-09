import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'dart:developer' as developer;
import '../models/ride_model.dart';
import '../services/api_service.dart';
import '../services/socket_service.dart';

class RideProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final SocketService _socketService = SocketService();
  
  Ride? _currentRide;
  List<Ride> _rideHistory = [];
  RideStatus _status = RideStatus.idle;
  LatLng? _driverLocation;
  final List<Map<String, dynamic>> _availableRides = []; // For drivers
  Map<String, dynamic>? _fareEstimate;

  Ride? get currentRide => _currentRide;
  List<Ride> get rideHistory => _rideHistory;
  RideStatus get status => _status;
  LatLng? get driverLocation => _driverLocation;
  List<Map<String, dynamic>> get availableRides => _availableRides;
  Map<String, dynamic>? get fareEstimate => _fareEstimate;
  
  void initialize() {
    _setupSocketListeners();
  }
  
  void _setupSocketListeners() {
    _socketService.onRideUpdate((data) {
      if (data['rideId'] == _currentRide?.id) {
        _updateRideFromSocket(data);
      }
    });
    
    _socketService.onDriverLocation((data) {
      if (data['rideId'] == _currentRide?.id) {
        _driverLocation = LatLng(data['lat'], data['lng']);
        notifyListeners();
      }
    });
    
    _socketService.onRideAccepted((data) {
      if (data['rideId'] == _currentRide?.id) {
        _currentRide = Ride.fromJson(data['ride']);
        _status = RideStatus.accepted;
        notifyListeners();
      }
    });
    
    _socketService.onNewRideRequest((data) {
      _availableRides.add(data);
      notifyListeners();
    });
    
    _socketService.onRideCancelled((data) {
      if (data['rideId'] == _currentRide?.id) {
        _currentRide = null;
        _status = RideStatus.cancelled;
        notifyListeners();
      }
    });
  }
  
  void _updateRideFromSocket(Map<String, dynamic> data) {
    final newStatus = _parseStatus(data['status']);
    _status = newStatus;
    if (_currentRide != null) {
      _currentRide = _currentRide!.copyWith(status: newStatus);
    }
    notifyListeners();
  }
  
  RideStatus _parseStatus(String status) {
    switch (status) {
      case 'searching': return RideStatus.searching;
      case 'accepted': return RideStatus.accepted;
      case 'arrived': return RideStatus.arrived;
      case 'started': return RideStatus.started;
      case 'completed': return RideStatus.completed;
      case 'cancelled': return RideStatus.cancelled;
      default: return RideStatus.idle;
    }
  }
  
  Future<bool> estimateFare({
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
    required String vehicleType,
  }) async {
    try {
      _fareEstimate = await _apiService.estimateFare(
        pickupLat: pickupLat,
        pickupLng: pickupLng,
        dropLat: dropLat,
        dropLng: dropLng,
        vehicleType: vehicleType,
      );
      notifyListeners();
      return true;
    } catch (e) {
      developer.log('Fare estimate error', error: e, name: 'RideProvider');
      return false;
    }
  }

  Future<bool> requestRide({
    required String pickupAddress,
    required String dropoffAddress,
    required double pickupLat,
    required double pickupLng,
    required double dropoffLat,
    required double dropoffLng,
    required String vehicleType,
  }) async {
    try {
      _status = RideStatus.searching;
      notifyListeners();

      final response = await _apiService.requestRide({
        'pickup': {
          'address': pickupAddress,
          'lat': pickupLat,
          'lng': pickupLng,
        },
        'dropoff': {
          'address': dropoffAddress,
          'lat': dropoffLat,
          'lng': dropoffLng,
        },
        'vehicleType': vehicleType,
      });

      _currentRide = Ride.fromJson(response['ride']);
      _status = RideStatus.searching;
      notifyListeners();
      return true;
    } catch (e) {
      developer.log('Request ride error', error: e, name: 'RideProvider');
      _status = RideStatus.idle;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> acceptRide(String rideId) async {
    try {
      final response = await _apiService.acceptRide(rideId);
      _currentRide = Ride.fromJson(response['ride']);
      _status = RideStatus.accepted;
      notifyListeners();
      return true;
    } catch (e) {
      developer.log('Accept ride error', error: e, name: 'RideProvider');
      return false;
    }
  }
  
  Future<bool> startRide() async {
    if (_currentRide == null) return false;
    
    try {
      await _apiService.startRide(_currentRide!.id);
      _status = RideStatus.started;
      _currentRide = _currentRide!.copyWith(status: RideStatus.started);
      notifyListeners();
      return true;
    } catch (e) {
      developer.log('Start ride error', error: e, name: 'RideProvider');
      return false;
    }
  }
  
  Future<bool> completeRide() async {
    if (_currentRide == null) return false;
    
    try {
      await _apiService.completeRide(_currentRide!.id);
      _rideHistory.insert(0, _currentRide!);
      _currentRide = null;
      _status = RideStatus.completed;
      _driverLocation = null;
      notifyListeners();
      return true;
    } catch (e) {
      developer.log('Complete ride error', error: e, name: 'RideProvider');
      return false;
    }
  }
  
  Future<bool> cancelRide() async {
    if (_currentRide == null) return false;
    
    try {
      await _apiService.cancelRide(_currentRide!.id);
      _currentRide = null;
      _status = RideStatus.cancelled;
      _driverLocation = null;
      notifyListeners();
      return true;
    } catch (e) {
      developer.log('Cancel ride error', error: e, name: 'RideProvider');
      return false;
    }
  }
  
  Future<void> loadRideHistory() async {
    try {
      final response = await _apiService.getRideHistory();
      _rideHistory = (response['rides'] as List)
          .map((ride) => Ride.fromJson(ride))
          .toList();
      notifyListeners();
    } catch (e) {
      developer.log('Load ride history error', error: e, name: 'RideProvider');
    }
  }
  
  Future<bool> rateRide(String rideId, double rating, String? comment) async {
    try {
      await _apiService.rateRide(rideId, rating, comment);
      return true;
    } catch (e) {
      developer.log('Rate ride error', error: e, name: 'RideProvider');
      return false;
    }
  }
  
  void clearCurrentRide() {
    _currentRide = null;
    _status = RideStatus.idle;
    _driverLocation = null;
    _fareEstimate = null;
    notifyListeners();
  }
  
  @override
  void dispose() {
    _socketService.removeListener('ride_update');
    _socketService.removeListener('driver_location');
    _socketService.removeListener('ride_accepted');
    _socketService.removeListener('new_ride_request');
    _socketService.removeListener('ride_cancelled');
    super.dispose();
  }
}