import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MapController _mapController = MapController();
  LatLng? _currentPosition;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _isLoading = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      _mapController.move(_currentPosition!, 15.0);
    } catch (e) {
      setState(() => _isLoading = false);
      developer.log('Error getting location', error: e, name: 'HomePage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition ?? LatLng(0, 0),
              initialZoom: 15.0,
              minZoom: 5.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.laijau.app',
              ),
              if (_currentPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentPosition!,
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Search Bar
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Builder(
                  builder: (context) => Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.menu, color: Colors.black),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Where to?',
                                border: InputBorder.none,
                              ),
                              onTap: () {
                            
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Plan your ride',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                   
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Book a Ride',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading Indicator
          if (_isLoading)
            Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}