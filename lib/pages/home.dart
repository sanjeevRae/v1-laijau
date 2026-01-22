import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:laijau/pages/profile_screen.dart';
import 'fare_estimation_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MapController _mapController = MapController();
  LatLng? _currentPosition;
  bool _isLoading = true;
  bool _isSelectingLocationOnMap = false;
  LatLng? _selectedMapLocation;
  String _selectingFor = ''; // 'from' or 'to'

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    for (var controller in _stopControllers) {
      controller.dispose();
    }
    super.dispose();
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

      if (!mounted) return;

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      if (_currentPosition != null) {
        _mapController.move(_currentPosition!, 15.0);
      }
    } catch (e) {
      developer.log('Error getting location', error: e, name: 'HomePage');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        // Set default position to Kathmandu if location fails
        _currentPosition = LatLng(27.7172, 85.3240);
      });
    }
  }

  // Controllers for the 'from' and 'to' fields
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  // Selected vehicle type
  String _selectedVehicle = 'car'; // default to car

  bool _isSearchExpanded = false;

  List<TextEditingController> _stopControllers = [];
  List<String> _recentLocations = [
    'Kathmandu Durbar Square',
    'Tribhuvan International Airport',
    'Patan Durbar Square',
  ];

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
              initialCenter: _currentPosition ?? LatLng(27.7172, 85.3240),
              initialZoom: 15.0,
              minZoom: 5.0,
              maxZoom: 18.0,
              onTap: _isSelectingLocationOnMap
                  ? (tapPosition, point) {
                      setState(() {
                        _selectedMapLocation = point;
                      });
                    }
                  : null,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.laijau.app',
              ),
              if (_currentPosition != null && !_isSelectingLocationOnMap)
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
              // Show selected location marker when picking location
              if (_isSelectingLocationOnMap && _selectedMapLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedMapLocation!,
                      width: 50,
                      height: 50,
                      child: Column(
                        children: [
                          Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 50,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Top left nav/menu button
          Positioned(
            top: 40,
            left: 16,
            child: Builder(
              builder: (context) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
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
          ),

          // Navigation button at bottom right
          if (!_isSelectingLocationOnMap)
            Positioned(
              bottom: 360, // Above the search bar with more clearance
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      _centerOnCurrentLocation();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(14),
                      child: Icon(
                        Icons.my_location,
                        color: Colors.green[700],
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Bottom Uber-style Search Bar (without nav button)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _isSearchExpanded
                  ? MediaQuery.of(context).size.height * 0.75
                  : null,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: _isSearchExpanded
                  ? _buildExpandedSearch()
                  : _buildCompactSearch(),
            ),
          ),

          // Map Location Picker Overlay
          if (_isSelectingLocationOnMap)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 50, 16, 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: _cancelMapSelection,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select Location',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Tap anywhere on the map to pin location',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // Recenter button during location selection
          if (_isSelectingLocationOnMap)
            Positioned(
              bottom: 120,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: _centerOnCurrentLocation,
                    child: Padding(
                      padding: EdgeInsets.all(14),
                      child: Icon(
                        Icons.my_location,
                        color: Colors.green[700],
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Done button for map selection
          if (_isSelectingLocationOnMap && _selectedMapLocation != null)
            Positioned(
              bottom: 40,
              left: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _confirmMapSelection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 28),
                      SizedBox(width: 12),
                      Text(
                        'Confirm Location',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Loading Indicator
          if (_isLoading)
            Container(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildCompactSearch() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Vehicle Type Selection - Horizontal Scroll
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildVehicleOption(
                icon: Icons.two_wheeler,
                label: 'Bike',
                value: 'motorcycle',
              ),
              SizedBox(width: 10),
              _buildVehicleOption(
                icon: Icons.directions_car,
                label: 'Car',
                value: 'car',
              ),
              SizedBox(width: 10),
              _buildVehicleOption(
                icon: Icons.car_rental,
                label: 'Premium',
                value: 'carplus',
              ),
              SizedBox(width: 10),
              _buildVehicleOption(
                icon: Icons.delivery_dining,
                label: 'Delivery',
                value: 'delivery',
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        // FROM field (man hailing hand icon, pickup location)
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _fromController,
            onTap: () {
              setState(() {
                _isSearchExpanded = true;
              });
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.emoji_people, color: Colors.green),
              hintText: 'What is your pickup location?',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            ),
          ),
        ),
        SizedBox(height: 10),
        // TO field (location icon, destination, plus icon)
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _toController,
            onTap: () {
              setState(() {
                _isSearchExpanded = true;
              });
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.location_on, color: Colors.red),
              hintText: 'Where are you going?',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              suffixIcon: IconButton(
                icon: Icon(Icons.add, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    _isSearchExpanded = true;
                    _addStop();
                  });
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            _bookRide();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text('Book a Ride', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }

  Widget _buildExpandedSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with back button
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  _isSearchExpanded = false;
                });
              },
            ),
            Text(
              'Plan Your Route',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // FROM field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _fromController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.emoji_people, color: Colors.green),
                      hintText: 'What is your pickup location?',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 8,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // TO field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _toController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_on, color: Colors.red),
                      hintText: 'Where are you going?',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 8,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add, color: Colors.green[700]),
                        onPressed: _addStop,
                      ),
                    ),
                  ),
                ),

                // Multiple stops
                ..._stopControllers.asMap().entries.map((entry) {
                  int index = entry.key;
                  TextEditingController controller = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.add_location,
                            color: Colors.orange,
                          ),
                          hintText: 'Add stop ${index + 1}',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 8,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.close, color: Colors.red),
                            onPressed: () => _removeStop(index),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),

                // Helper message
                if (_stopControllers.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 8, left: 8),
                    child: Text(
                      'Please keep the stops under 5 mins.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                SizedBox(height: 20),

                // Choose on map option
                ListTile(
                  leading: Icon(Icons.map, color: Colors.green[700]),
                  title: Text(
                    'Choose on map',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'Tap to select location from map',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  trailing: Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    _openMapLocationPicker();
                  },
                  tileColor: Colors.grey[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                SizedBox(height: 20),

                // Recent locations
                Text(
                  'Recent Locations',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 10),

                ..._recentLocations.map((location) {
                  return ListTile(
                    leading: Icon(Icons.history, color: Colors.grey[600]),
                    title: Text(location),
                    onTap: () {
                      setState(() {
                        _toController.text = location;
                      });
                    },
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                  );
                }).toList(),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // Book button at bottom
        ElevatedButton(
          onPressed: () {
            _bookRide();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text('Confirm Route', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }

  void _addStop() {
    if (_stopControllers.length < 3) {
      // Maximum 3 stops
      setState(() {
        _stopControllers.add(TextEditingController());
      });
    }
  }

  void _removeStop(int index) {
    setState(() {
      _stopControllers[index].dispose();
      _stopControllers.removeAt(index);
    });
  }

  Widget _buildVehicleOption({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final isSelected = _selectedVehicle == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedVehicle = value;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 85,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [Colors.green[600]!, Colors.green[800]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.grey[50],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.green[700]! : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 28,
            ),
            SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
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
              color: Color(0xFF00BF6D), // App green
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.black),
            ),
            accountName: Text(
              'User Name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text('+977 9876543210'),
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.black),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.history, color: Colors.black),
            title: Text('Ride History'),
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
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 8),
            Text('Version 1.0.0'),
            SizedBox(height: 16),
            Text(
              'A modern ride-sharing platform connecting passengers and riders.',
            ),
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
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Map location picker methods
  void _openMapLocationPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose Location For'),
        content: Text(
          'Select whether this location is for pickup or destination',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startMapSelection('from');
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_people, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Text('Pickup', style: TextStyle(color: Colors.green[700])),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startMapSelection('to');
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on, color: Colors.red, size: 20),
                SizedBox(width: 8),
                Text('Destination', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startMapSelection(String selectingFor) {
    setState(() {
      _isSelectingLocationOnMap = true;
      _selectingFor = selectingFor;
      _selectedMapLocation = _currentPosition; // Start with current position
      _isSearchExpanded = false;
    });

    // Move map to current position
    if (_currentPosition != null) {
      _mapController.move(_currentPosition!, 15.0);
    }
  }

  void _cancelMapSelection() {
    setState(() {
      _isSelectingLocationOnMap = false;
      _selectedMapLocation = null;
      _selectingFor = '';
    });
  }

  void _confirmMapSelection() {
    if (_selectedMapLocation == null) return;

    // Format coordinates as address placeholder
    String locationText =
        '${_selectedMapLocation!.latitude.toStringAsFixed(4)}, ${_selectedMapLocation!.longitude.toStringAsFixed(4)}';

    setState(() {
      if (_selectingFor == 'from') {
        _fromController.text = locationText;
      } else if (_selectingFor == 'to') {
        _toController.text = locationText;
      }
      _isSelectingLocationOnMap = false;
      _selectedMapLocation = null;
      _selectingFor = '';
    });

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Location selected successfully!',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green[400],
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          top: 80,
          left: 16,
          right: 16,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _centerOnCurrentLocation() async {
    if (_currentPosition != null) {
      _mapController.move(_currentPosition!, 15.0);

      // Provide haptic feedback if available
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.my_location, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text('Centered on your location'),
            ],
          ),
          backgroundColor: Colors.blue[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      // Try to get location if not available
      if (!mounted) return;
      setState(() => _isLoading = true);
      await _getCurrentLocation();
      if (!mounted) return;
      if (_currentPosition != null) {
        _mapController.move(_currentPosition!, 15.0);
      }
    }
  }

  void _bookRide() {
    // Validate inputs
    if (_fromController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 12),
              Text('Please enter pickup location'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    if (_toController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 12),
              Text('Please enter destination'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    // Navigate to fare estimation screen
    if (!mounted) return;
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FareEstimationScreen(
            fromLocation: _fromController.text,
            toLocation: _toController.text,
            fromCoords: _currentPosition ?? LatLng(27.7172, 85.3240),
            toCoords: null, // Could be set if location was selected from map
          ),
        ),
      );
    } catch (e) {
      developer.log('Navigation error', error: e, name: 'HomePage');
    }
  }
}
