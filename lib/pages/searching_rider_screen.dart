import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'choose_driver_screen.dart';
import '../models/driver_model.dart';

class SearchingRiderScreen extends StatefulWidget {
  final String fromLocation;
  final String toLocation;
  final String vehicleType;
  final int estimatedFare;
  final bool autoAccept;

  const SearchingRiderScreen({
    super.key,
    required this.fromLocation,
    required this.toLocation,
    required this.vehicleType,
    required this.estimatedFare,
    required this.autoAccept,
  });

  @override
  State<SearchingRiderScreen> createState() => _SearchingRiderScreenState();
}

class _SearchingRiderScreenState extends State<SearchingRiderScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _searchingSeconds = 60;
  int _viewingDrivers = 0;
  Timer? _searchTimer;
  Timer? _countdownTimer;
  List<Driver> _availableDrivers = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _startSearching();
  }

  void _startSearching() {
    // Simulate drivers viewing the request
    _searchTimer = Timer.periodic(Duration(milliseconds: 1500), (timer) {
      if (mounted) {
        setState(() {
          _viewingDrivers = min(_viewingDrivers + Random().nextInt(2), 5);
        });
      }
    });

    // Countdown timer
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _searchingSeconds--;
        });
        if (_searchingSeconds <= 0) {
          timer.cancel();
        }
      }
    });

    // Simulate finding drivers after 4 seconds
    Future.delayed(Duration(seconds: 4), () {
      if (mounted) {
        _mockFindDrivers();
      }
    });
  }

  void _mockFindDrivers() {
    // Create mock drivers
    final drivers = [
      Driver(
        id: '1',
        name: 'Sunil',
        rating: 4.11,
        totalRides: 1180,
        vehicle: 'Maruti Suzuki 800',
        vehicleNumber: 'BA 5 PA 1234',
        distanceInKm: 2.5,
        estimatedArrivalMinutes: 6,
      ),
      Driver(
        id: '2',
        name: 'Rajesh Kumar',
        rating: 4.8,
        totalRides: 2340,
        vehicle: 'Honda City',
        vehicleNumber: 'BA 1 CH 5678',
        distanceInKm: 3.2,
        estimatedArrivalMinutes: 8,
      ),
      Driver(
        id: '3',
        name: 'Prakash Thapa',
        rating: 4.5,
        totalRides: 890,
        vehicle: 'Suzuki Swift',
        vehicleNumber: 'BA 2 KA 9012',
        distanceInKm: 1.8,
        estimatedArrivalMinutes: 5,
      ),
    ];

    setState(() {
      _availableDrivers = drivers;
    });

    // Navigate to driver selection
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseDriverScreen(
          fromLocation: widget.fromLocation,
          toLocation: widget.toLocation,
          vehicleType: widget.vehicleType,
          estimatedFare: widget.estimatedFare,
          availableDrivers: _availableDrivers,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString()}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Stack(
          children: [
            // Map background
            Positioned.fill(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(27.7172, 85.3240), // Kathmandu coordinates
                  initialZoom: 14.0,
                  minZoom: 5.0,
                  maxZoom: 18.0,
                  interactionOptions: InteractionOptions(
                    flags: InteractiveFlag.none, // Disable interaction during search
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.laijau.app',
                  ),
                ],
              ),
            ),

            // Semi-transparent overlay with animated ripple
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(0.85),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Animated ripple circles
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: RipplePainter(
                            animationValue: _animationController.value,
                          ),
                          child: Container(),
                        );
                      },
                    ),
                    // Center location icon
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Top location info
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.green[700], size: 12),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.fromLocation,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.red[600],
                          size: 12,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.toLocation,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Viewing drivers indicator
            if (_viewingDrivers > 0)
              Positioned(
                top: 120,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...List.generate(
                          min(_viewingDrivers, 3),
                          (index) => Container(
                            margin: EdgeInsets.only(right: 8),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.green[100],
                              child: Icon(
                                Icons.person,
                                size: 18,
                                color: Colors.green[700],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          '$_viewingDrivers ${_viewingDrivers == 1 ? 'driver is' : 'drivers are'} viewing your request',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Bottom info card
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Priority message
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.priority_high,
                            color: Colors.green[700],
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Your request is priority in queue',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    // Timer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.timer, color: Colors.grey[600], size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Finding riders...',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          _formatTime(_searchingSeconds),
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (_searchingSeconds / 60),
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.green[700]!,
                        ),
                        minHeight: 4,
                      ),
                    ),

                    SizedBox(height: 24),

                    // Fare adjustment
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              // Decrease fare
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.grey[100],
                              side: BorderSide(color: Colors.grey[300]!),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              '-10',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'NPR${widget.estimatedFare}',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              // Increase fare
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.grey[100],
                              side: BorderSide(color: Colors.grey[300]!),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              '+10',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Raise fare button
                    ElevatedButton(
                      onPressed: () {
                        // Raise fare functionality
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text('Raise fare', style: TextStyle(fontSize: 16)),
                    ),

                    SizedBox(height: 16),

                    // Cancel button
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.close, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            'Cancel request',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RipplePainter extends CustomPainter {
  final double animationValue;

  RipplePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw 3 ripple circles
    for (int i = 0; i < 3; i++) {
      final radius = (animationValue + i / 3) * 150;
      final opacity = 1.0 - ((animationValue + i / 3) % 1.0);

      paint.color = Colors.green.withOpacity(opacity * 0.2);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) => true;
}
