enum RideStatus {
  idle,
  searching,
  accepted,
  arrived,
  started,
  completed,
  cancelled,
}

class Ride {
  final String id;
  final String pickupAddress;
  final String dropoffAddress;
  final double pickupLat;
  final double pickupLng;
  final double dropoffLat;
  final double dropoffLng;
  final double fare;
  final RideStatus status;
  final String? driverId;
  final String? driverName;
  final String? driverPhone;
  final String? vehicleNumber;
  final String? vehicleType;
  final double? driverRating;
  final double? distance;
  final int? duration;
  final DateTime? createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;

  Ride({
    required this.id,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffLat,
    required this.dropoffLng,
    required this.fare,
    required this.status,
    this.driverId,
    this.driverName,
    this.driverPhone,
    this.vehicleNumber,
    this.vehicleType,
    this.driverRating,
    this.distance,
    this.duration,
    this.createdAt,
    this.startedAt,
    this.completedAt,
  });

  Ride copyWith({
    String? id,
    String? pickupAddress,
    String? dropoffAddress,
    double? pickupLat,
    double? pickupLng,
    double? dropoffLat,
    double? dropoffLng,
    double? fare,
    RideStatus? status,
    String? driverId,
    String? driverName,
    String? driverPhone,
    String? vehicleNumber,
    String? vehicleType,
    double? driverRating,
    double? distance,
    int? duration,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return Ride(
      id: id ?? this.id,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      dropoffAddress: dropoffAddress ?? this.dropoffAddress,
      pickupLat: pickupLat ?? this.pickupLat,
      pickupLng: pickupLng ?? this.pickupLng,
      dropoffLat: dropoffLat ?? this.dropoffLat,
      dropoffLng: dropoffLng ?? this.dropoffLng,
      fare: fare ?? this.fare,
      status: status ?? this.status,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      driverRating: driverRating ?? this.driverRating,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pickupAddress': pickupAddress,
      'dropoffAddress': dropoffAddress,
      'pickupLat': pickupLat,
      'pickupLng': pickupLng,
      'dropoffLat': dropoffLat,
      'dropoffLng': dropoffLng,
      'fare': fare,
      'status': status.toString().split('.').last,
      'driverId': driverId,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'vehicleNumber': vehicleNumber,
      'vehicleType': vehicleType,
      'driverRating': driverRating,
      'distance': distance,
      'duration': duration,
      'createdAt': createdAt?.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'] ?? '',
      pickupAddress: json['pickupAddress'] ?? json['pickup']?['address'] ?? '',
      dropoffAddress: json['dropoffAddress'] ?? json['dropoff']?['address'] ?? '',
      pickupLat: (json['pickupLat'] ?? json['pickup']?['lat'] ?? 0).toDouble(),
      pickupLng: (json['pickupLng'] ?? json['pickup']?['lng'] ?? 0).toDouble(),
      dropoffLat: (json['dropoffLat'] ?? json['dropoff']?['lat'] ?? 0).toDouble(),
      dropoffLng: (json['dropoffLng'] ?? json['dropoff']?['lng'] ?? 0).toDouble(),
      fare: (json['fare'] ?? 0).toDouble(),
      status: _parseStatus(json['status']),
      driverId: json['driverId'] ?? json['driver']?['id'],
      driverName: json['driverName'] ?? json['driver']?['name'],
      driverPhone: json['driverPhone'] ?? json['driver']?['phone'],
      vehicleNumber: json['vehicleNumber'] ?? json['vehicle']?['number'],
      vehicleType: json['vehicleType'] ?? json['vehicle']?['type'],
      driverRating: json['driverRating']?.toDouble() ?? json['driver']?['rating']?.toDouble(),
      distance: json['distance']?.toDouble(),
      duration: json['duration'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      startedAt: json['startedAt'] != null ? DateTime.parse(json['startedAt']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
    );
  }
  
  static RideStatus _parseStatus(dynamic status) {
    if (status == null) return RideStatus.idle;
    final statusStr = status.toString().toLowerCase();
    
    switch (statusStr) {
      case 'searching':
        return RideStatus.searching;
      case 'accepted':
        return RideStatus.accepted;
      case 'arrived':
        return RideStatus.arrived;
      case 'started':
      case 'inprogress':
        return RideStatus.started;
      case 'completed':
        return RideStatus.completed;
      case 'cancelled':
        return RideStatus.cancelled;
      default:
        return RideStatus.idle;
    }
  }
}
