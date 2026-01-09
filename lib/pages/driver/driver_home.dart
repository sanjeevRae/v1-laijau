import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../providers/auth_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/ride_provider.dart';
import '../../models/ride_model.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  final MapController _mapController = MapController();
  bool _isOnline = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    final locationProvider = context.read<LocationProvider>();
    await locationProvider.getCurrentLocation();
    
    if (locationProvider.currentLocation != null) {
      _mapController.move(locationProvider.currentLocation!, 15.0);
    }
  }

  void _toggleOnlineStatus() {
    setState(() {
      _isOnline = !_isOnline;
    });
    
    final locationProvider = context.read<LocationProvider>();
    if (_isOnline) {
      locationProvider.startTracking(emitToServer: true);
    } else {
      locationProvider.stopTracking();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          Consumer<LocationProvider>(
            builder: (context, locationProvider, _) {
              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: locationProvider.currentLocation ?? LatLng(0, 0),
                  initialZoom: 15.0,
                  minZoom: 5.0,
                  maxZoom: 18.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.laijau.app',
                  ),
                  if (locationProvider.currentLocation != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: locationProvider.currentLocation!,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.local_taxi,
                            color: Colors.green,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                ],
              );
            },
          ),

          // Top Bar
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black),
                    onPressed: () => _showMenu(context),
                  ),
                ),
                Card(
                  color: _isOnline ? Colors.green : Colors.grey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      _isOnline ? 'ONLINE' : 'OFFLINE',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Online/Offline Toggle
          Positioned(
            bottom: 200,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: _toggleOnlineStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isOnline ? Colors.red : Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  _isOnline ? 'Go Offline' : 'Go Online',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // Earnings Card
          if (_isOnline)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Today\'s Earnings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '\$0.00',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('Trips', '0'),
                        _buildStat('Hours', '0.0'),
                        _buildStat('Distance', '0 km'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // Ride Requests
          Consumer<RideProvider>(
            builder: (context, rideProvider, _) {
              if (rideProvider.currentRide != null) {
                return _buildCurrentRideCard(rideProvider.currentRide!);
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentRideCard(Ride ride) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Ride - ${ride.status.toString().split('.').last.toUpperCase()}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.green),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    ride.pickupAddress,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    ride.dropoffAddress,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (ride.status == RideStatus.accepted)
              ElevatedButton(
                onPressed: () {
                  context.read<RideProvider>().startRide();
                },
                child: const Text('START RIDE'),
              )
            else if (ride.status == RideStatus.started)
              ElevatedButton(
                onPressed: () {
                  context.read<RideProvider>().completeRide();
                },
                child: const Text('COMPLETE RIDE'),
              ),
          ],
        ),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Earnings History'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.directions_car),
                title: const Text('Vehicle Info'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: () {
                  context.read<AuthProvider>().logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    context.read<LocationProvider>().stopTracking();
    super.dispose();
  }
}
