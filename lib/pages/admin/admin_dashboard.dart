import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _buildDashboardCard(
              'Total Rides',
              '1,234',
              Icons.local_taxi,
              Colors.blue,
            ),
            _buildDashboardCard(
              'Active Riders',
              '567',
              Icons.person,
              Colors.green,
            ),
            _buildDashboardCard(
              'Active Drivers',
              '89',
              Icons.directions_car,
              Colors.orange,
            ),
            _buildDashboardCard(
              'Total Revenue',
              '\$45,678',
              Icons.attach_money,
              Colors.purple,
            ),
            _buildDashboardCard(
              'Pending Approvals',
              '12',
              Icons.pending,
              Colors.red,
            ),
            _buildDashboardCard(
              'Support Tickets',
              '23',
              Icons.support_agent,
              Colors.teal,
            ),
          ],
        ),
      ),
      drawer: _buildDrawer(context),
    );
  }

  Widget _buildDashboardCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.black),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Laijau Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('User Management'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.directions_car),
            title: const Text('Driver Verification'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.local_taxi),
            title: const Text('Ride Management'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Analytics'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
