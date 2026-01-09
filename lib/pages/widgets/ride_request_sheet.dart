import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/ride_provider.dart';
import '../../models/ride_model.dart';
import 'address_search_page.dart';

class RideRequestSheet extends StatefulWidget {
  const RideRequestSheet({super.key});

  @override
  State<RideRequestSheet> createState() => _RideRequestSheetState();
}

class _RideRequestSheetState extends State<RideRequestSheet> {
  String _selectedVehicleType = 'standard';

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();
    final rideProvider = context.watch<RideProvider>();

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
            const Text(
              'Where to?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Pickup Location
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddressSearchPage(isPickup: true),
                  ),
                );
                if (result != null) {
                  locationProvider.setPickupLocation(
                    result['location'],
                    address: result['address'],
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.circle, color: Colors.green, size: 20),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        locationProvider.pickupAddress ?? 'Set pickup location',
                        style: TextStyle(
                          fontSize: 16,
                          color: locationProvider.pickupAddress != null
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 15),
            
            // Dropoff Location
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddressSearchPage(isPickup: false),
                  ),
                );
                if (result != null) {
                  locationProvider.setDropoffLocation(
                    result['location'],
                    address: result['address'],
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 20),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        locationProvider.dropoffAddress ?? 'Where to?',
                        style: TextStyle(
                          fontSize: 16,
                          color: locationProvider.dropoffAddress != null
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Vehicle Type Selection
            const Text(
              'Select Vehicle Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildVehicleTypeButton('standard', 'Standard', Icons.directions_car),
                const SizedBox(width: 10),
                _buildVehicleTypeButton('premium', 'Premium', Icons.local_taxi),
                const SizedBox(width: 10),
                _buildVehicleTypeButton('xl', 'XL', Icons.airport_shuttle),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Fare Estimate
            if (rideProvider.fareEstimate != null)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Estimated Fare:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '\$${rideProvider.fareEstimate!['fare'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 20),
            
            // Request Ride Button
            ElevatedButton(
              onPressed: (locationProvider.pickupLocation != null &&
                      locationProvider.dropoffLocation != null)
                  ? () => _requestRide(context)
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: rideProvider.status == RideStatus.searching
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Request Ride', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleTypeButton(String type, String label, IconData icon) {
    final isSelected = _selectedVehicleType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedVehicleType = type);
          _estimateFare();
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.black : Colors.grey[300]!,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? Colors.black.withValues(alpha: 0.05) : Colors.white,
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.black : Colors.grey),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _estimateFare() async {
    final locationProvider = context.read<LocationProvider>();
    final rideProvider = context.read<RideProvider>();

    if (locationProvider.pickupLocation != null &&
        locationProvider.dropoffLocation != null) {
      await rideProvider.estimateFare(
        pickupLat: locationProvider.pickupLocation!.latitude,
        pickupLng: locationProvider.pickupLocation!.longitude,
        dropLat: locationProvider.dropoffLocation!.latitude,
        dropLng: locationProvider.dropoffLocation!.longitude,
        vehicleType: _selectedVehicleType,
      );
    }
  }

  Future<void> _requestRide(BuildContext context) async {
    final locationProvider = context.read<LocationProvider>();
    final rideProvider = context.read<RideProvider>();

    final success = await rideProvider.requestRide(
      pickupAddress: locationProvider.pickupAddress!,
      dropoffAddress: locationProvider.dropoffAddress!,
      pickupLat: locationProvider.pickupLocation!.latitude,
      pickupLng: locationProvider.pickupLocation!.longitude,
      dropoffLat: locationProvider.dropoffLocation!.latitude,
      dropoffLng: locationProvider.dropoffLocation!.longitude,
      vehicleType: _selectedVehicleType,
    );

    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to request ride. Please try again.')),
      );
    }
  }
}
