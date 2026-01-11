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

          // Search Bar with Menu Button
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
                                // Search functionality
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
                      // Book ride functionality
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

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.black),
            ),
            accountName: Text(
              'User Name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text('+1 234 567 8900'),
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.black),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.history, color: Colors.black),
            title: Text('Ride History'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.payment, color: Colors.black),
            title: Text('Payment Methods'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.black),
            title: Text('Saved Places'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.black),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              _showSettings();
            },
          ),
          ListTile(
            leading: Icon(Icons.help, color: Colors.black),
            title: Text('Help & Support'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.black),
            title: Text('About'),
            onTap: () {
              Navigator.pop(context);
              _showAbout();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _logout();
            },
          ),
        ],
      ),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Settings',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildSettingTile(
                icon: Icons.notifications,
                title: 'Notifications',
                subtitle: 'Manage notification preferences',
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.lock,
                title: 'Privacy',
                subtitle: 'Control your privacy settings',
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'English',
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.dark_mode,
                title: 'Appearance',
                subtitle: 'Light mode',
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.location_on,
                title: 'Location Services',
                subtitle: 'Manage location permissions',
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.security,
                title: 'Security',
                subtitle: 'Password and authentication',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('About Laijau'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LAIJAU',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            SizedBox(height: 8),
            Text('Version 1.0.0'),
            SizedBox(height: 16),
            Text('A modern ride-sharing platform connecting passengers and riders.'),
            SizedBox(height: 16),
            Text('© 2026 Laijau. All rights reserved.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
