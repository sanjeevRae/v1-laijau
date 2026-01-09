import 'package:flutter/material.dart';
import '../../models/ride_model.dart';
import '../../services/call_service.dart';
import 'package:provider/provider.dart';
import '../../providers/ride_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RideStatusCard extends StatelessWidget {
  final Ride ride;

  const RideStatusCard({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
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
            _buildStatusHeader(),
            const SizedBox(height: 20),
            if (ride.driverName != null) _buildDriverInfo(),
            const SizedBox(height: 20),
            _buildLocationInfo(),
            const SizedBox(height: 20),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader() {
    String statusText;
    Color statusColor;

    switch (ride.status) {
      case RideStatus.searching:
        statusText = 'Finding a driver...';
        statusColor = Colors.orange;
        break;
      case RideStatus.accepted:
        statusText = 'Driver is on the way';
        statusColor = Colors.blue;
        break;
      case RideStatus.arrived:
        statusText = 'Driver has arrived';
        statusColor = Colors.green;
        break;
      case RideStatus.started:
        statusText = 'Trip in progress';
        statusColor = Colors.green;
        break;
      default:
        statusText = 'Unknown status';
        statusColor = Colors.grey;
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.local_taxi, color: statusColor),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                statusText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (ride.status == RideStatus.searching)
                const Text(
                  'This may take a few moments',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDriverInfo() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ride.driverName!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ride.vehicleNumber ?? 'Unknown vehicle',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                if (ride.driverRating != null)
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        ride.driverRating!.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.circle, color: Colors.green, size: 20),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                ride.pickupAddress,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(left: 9, top: 5, bottom: 5),
          width: 2,
          height: 30,
          color: Colors.grey[300],
        ),
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.red, size: 20),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                ride.dropoffAddress,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        if (ride.driverPhone != null) ...[
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _makePhoneCall(ride.driverPhone!),
              icon: const Icon(Icons.phone),
              label: const Text('Call'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _startVideoCall(context),
              icon: const Icon(Icons.video_call),
              label: const Text('Video'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
        if (ride.status == RideStatus.searching)
          Expanded(
            child: ElevatedButton(
              onPressed: () => _cancelRide(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Cancel'),
            ),
          ),
      ],
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _startVideoCall(BuildContext context) async {
    final callService = CallService();
    await callService.startCall(
      roomName: ride.id,
      displayName: 'Rider',
      isVideoMuted: false,
    );
  }

  Future<void> _cancelRide(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Ride?'),
        content: const Text('Are you sure you want to cancel this ride?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await context.read<RideProvider>().cancelRide();
      if (!success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to cancel ride')),
        );
      }
    }
  }
}
