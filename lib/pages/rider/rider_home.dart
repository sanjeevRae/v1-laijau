import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../providers/auth_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/ride_provider.dart';
import '../widgets/ride_request_sheet.dart';
import '../widgets/ride_status_card.dart';

class RiderHome extends StatefulWidget {
  const RiderHome({super.key});

  @override
  State<RiderHome> createState() => _RiderHomeState();
}

class _RiderHomeState extends State<RiderHome> {
  final MapController _mapController = MapController();

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
                            Icons.my_location,
                            color: Colors.blue,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  // Show driver location if ride is active
                  Consumer<RideProvider>(
                    builder: (context, rideProvider, _) {
                      if (rideProvider.driverLocation != null) {
                        return MarkerLayer(
                          markers: [
                            Marker(
                              point: rideProvider.driverLocation!,
                              width: 40,
                              height: 40,
                              child: const Icon(
                                Icons.local_taxi,
                                color: Colors.green,
                                size: 40,
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              );
            },
          ),

          // Top Bar with Menu and Notifications
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
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.black),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),

          // Ride Status or Request Sheet
          Consumer<RideProvider>(
            builder: (context, rideProvider, _) {
              if (rideProvider.currentRide != null) {
                return RideStatusCard(ride: rideProvider.currentRide!);
              }
              return const RideRequestSheet();
            },
          ),
        ],
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
                title: const Text('Ride History'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.payment),
                title: const Text('Payment Methods'),
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
}
