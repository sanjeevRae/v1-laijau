import 'package:flutter/material.dart';

class Driver {
  final String id;
  final String name;
  final double rating;
  final int totalRides;
  final String vehicle;
  final String vehicleNumber;
  final String? photoUrl;
  final double distanceInKm;
  final int estimatedArrivalMinutes;

  Driver({
    required this.id,
    required this.name,
    required this.rating,
    required this.totalRides,
    required this.vehicle,
    required this.vehicleNumber,
    this.photoUrl,
    required this.distanceInKm,
    required this.estimatedArrivalMinutes,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalRides: json['totalRides'] ?? 0,
      vehicle: json['vehicle'] ?? '',
      vehicleNumber: json['vehicleNumber'] ?? '',
      photoUrl: json['photoUrl'],
      distanceInKm: (json['distanceInKm'] ?? 0.0).toDouble(),
      estimatedArrivalMinutes: json['estimatedArrivalMinutes'] ?? 0,
    );
  }
}

class VehicleOption {
  final String type;
  final String name;
  final String description;
  final IconData icon;
  final int estimatedFare;
  final int estimatedTime;
  final int capacity;

  VehicleOption({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
    required this.estimatedFare,
    required this.estimatedTime,
    required this.capacity,
  });
}
