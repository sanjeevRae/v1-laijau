import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DriverVehicleInfo extends StatefulWidget {
  const DriverVehicleInfo({super.key});

  @override
  State<DriverVehicleInfo> createState() => _DriverVehicleInfoState();
}

class _DriverVehicleInfoState extends State<DriverVehicleInfo> {
  // Demo vehicle data
  final Map<String, dynamic> _vehicleData = {
    'make': 'Toyota',
    'model': 'Corolla',
    'year': 2020,
    'color': 'White',
    'licensePlate': 'BA 12 PA 3456',
    'vin': 'JT2BF22K9X0123456',
    'seats': 4,
    'mileage': 45230,
    'fuelType': 'Petrol',
    'transmission': 'Automatic',
  };

  final List<Map<String, dynamic>> _documents = [
    {
      'name': 'Vehicle Registration',
      'status': 'Verified',
      'expiry': DateTime(2026, 12, 31),
      'icon': Icons.description,
      'color': Colors.blue,
    },
    {
      'name': 'Insurance Certificate',
      'status': 'Verified',
      'expiry': DateTime(2026, 8, 15),
      'icon': Icons.shield,
      'color': Colors.green,
    },
    {
      'name': 'Fitness Certificate',
      'status': 'Verified',
      'expiry': DateTime(2026, 6, 30),
      'icon': Icons.verified_user,
      'color': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Vehicle Information',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.green[700]),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Edit feature coming soon'),
                  backgroundColor: Colors.green[700],
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Vehicle image card
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey[800]!, Colors.grey[900]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/welcome-image.png',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_vehicleData['year']} ${_vehicleData['make']} ${_vehicleData['model']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _vehicleData['licensePlate'],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Vehicle details
          Text(
            'Vehicle Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildDetailRow(Icons.palette, 'Color', _vehicleData['color']),
                Divider(height: 1),
                _buildDetailRow(Icons.event_seat, 'Seats', _vehicleData['seats'].toString()),
                Divider(height: 1),
                _buildDetailRow(Icons.speed, 'Mileage', '${_vehicleData['mileage']} km'),
                Divider(height: 1),
                _buildDetailRow(Icons.local_gas_station, 'Fuel Type', _vehicleData['fuelType']),
                Divider(height: 1),
                _buildDetailRow(Icons.settings, 'Transmission', _vehicleData['transmission']),
                Divider(height: 1),
                _buildDetailRow(Icons.fingerprint, 'VIN', _vehicleData['vin']),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Documents
          Text(
            'Documents',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          ..._documents.map((doc) => _buildDocumentCard(doc)).toList(),
          SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.green[700], size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(Map<String, dynamic> doc) {
    final isExpiring = doc['status'] == 'Expiring Soon';
    final daysUntilExpiry = doc['expiry'].difference(DateTime.now()).inDays;
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpiring ? Colors.red[200]! : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: doc['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(doc['icon'], color: doc['color'], size: 28),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      isExpiring ? Icons.warning : Icons.check_circle,
                      size: 14,
                      color: isExpiring ? Colors.red : Colors.green,
                    ),
                    SizedBox(width: 4),
                    Text(
                      doc['status'],
                      style: TextStyle(
                        color: isExpiring ? Colors.red : Colors.green,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Expires',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 11,
                ),
              ),
              Text(
                DateFormat('MMM d, y').format(doc['expiry']),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
              Text(
                '$daysUntilExpiry days',
                style: TextStyle(
                  color: isExpiring ? Colors.red : Colors.grey[600],
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
