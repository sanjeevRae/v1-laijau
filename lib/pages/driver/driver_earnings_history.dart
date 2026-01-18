import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EarningEntry {
  final DateTime date;
  final double amount;
  final int trips;
  final double hours;
  final double distance;

  EarningEntry({
    required this.date,
    required this.amount,
    required this.trips,
    required this.hours,
    required this.distance,
  });
}

class DriverEarningsHistory extends StatefulWidget {
  const DriverEarningsHistory({super.key});

  @override
  State<DriverEarningsHistory> createState() => _DriverEarningsHistoryState();
}

class _DriverEarningsHistoryState extends State<DriverEarningsHistory> {
  String _selectedPeriod = 'Week';
  final List<String> _periods = ['Today', 'Week', 'Month', 'Year'];

  // Demo data
  final List<EarningEntry> _demoEarnings = [
    EarningEntry(date: DateTime.now(), amount: 3850.50, trips: 12, hours: 8.5, distance: 156.3),
    EarningEntry(date: DateTime.now().subtract(Duration(days: 1)), amount: 4120.75, trips: 15, hours: 9.2, distance: 178.9),
    EarningEntry(date: DateTime.now().subtract(Duration(days: 2)), amount: 3200.00, trips: 10, hours: 7.0, distance: 132.5),
    EarningEntry(date: DateTime.now().subtract(Duration(days: 3)), amount: 4580.25, trips: 18, hours: 10.5, distance: 201.4),
    EarningEntry(date: DateTime.now().subtract(Duration(days: 4)), amount: 3950.50, trips: 13, hours: 8.8, distance: 165.2),
    EarningEntry(date: DateTime.now().subtract(Duration(days: 5)), amount: 2850.00, trips: 9, hours: 6.5, distance: 118.7),
    EarningEntry(date: DateTime.now().subtract(Duration(days: 6)), amount: 5120.80, trips: 20, hours: 11.2, distance: 225.6),
  ];

  double get _totalEarnings => _demoEarnings.fold(0, (sum, item) => sum + item.amount);
  int get _totalTrips => _demoEarnings.fold(0, (sum, item) => sum + item.trips);
  double get _totalHours => _demoEarnings.fold(0, (sum, item) => sum + item.hours);
  double get _averagePerTrip => _totalEarnings / _totalTrips;

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
          'Earnings History',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download, color: Colors.green[700]),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Downloading earnings report...'),
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
          // Period selector
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _periods.length,
              itemBuilder: (context, index) {
                final period = _periods[index];
                final isSelected = _selectedPeriod == period;
                return Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedPeriod = period);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(colors: [Colors.green[600]!, Colors.green[700]!])
                            : null,
                        color: isSelected ? null : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          period,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 24),

          // Summary card
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green[600]!, Colors.green[700]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Total Earnings',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'NPR ${_totalEarnings.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1,
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryStat(Icons.directions_car, _totalTrips.toString(), 'Trips'),
                    Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
                    _buildSummaryStat(Icons.access_time, '${_totalHours.toStringAsFixed(1)}h', 'Hours'),
                    Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
                    _buildSummaryStat(Icons.attach_money, 'NPR ${_averagePerTrip.toStringAsFixed(0)}', 'Avg/Trip'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Chart placeholder
          Container(
            height: 200,
            padding: EdgeInsets.all(20),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Earnings Trend',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: _buildSimpleChart(),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Daily breakdown
          Text(
            'Daily Breakdown',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          ..._demoEarnings.map((entry) => _buildEarningCard(entry)).toList(),
          SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleChart() {
    final maxAmount = _demoEarnings.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: _demoEarnings.reversed.map((entry) {
        final height = (entry.amount / maxAmount) * 140;
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 32,
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[400]!, Colors.green[700]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
            ),
            SizedBox(height: 8),
            Text(
              DateFormat('E').format(entry.date).substring(0, 1),
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildEarningCard(EarningEntry entry) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE, MMM d').format(entry.date),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${entry.trips} trips • ${entry.hours.toStringAsFixed(1)} hours',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'NPR ${entry.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${entry.distance.toStringAsFixed(1)} km',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMiniStat(Icons.speed, 'NPR ${(entry.amount / entry.trips).toStringAsFixed(0)}/trip'),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildMiniStat(Icons.timer, 'NPR ${(entry.amount / entry.hours).toStringAsFixed(0)}/hr'),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildMiniStat(Icons.map, 'NPR ${(entry.amount / entry.distance).toStringAsFixed(0)}/km'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.green[700]),
          SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: TextStyle(fontSize: 11, color: Colors.green[700], fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
