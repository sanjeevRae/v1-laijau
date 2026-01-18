import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverSettings extends StatefulWidget {
  const DriverSettings({super.key});

  @override
  State<DriverSettings> createState() => _DriverSettingsState();
}

class _DriverSettingsState extends State<DriverSettings> {
  bool _pushNotifications = true;
  bool _soundEffects = true;
  bool _autoAcceptRides = false;
  bool _showEarningsOnMap = true;
  String _navigationApp = 'Google Maps';
  String _language = 'English';
  double _acceptanceRadius = 5.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
      _soundEffects = prefs.getBool('sound_effects') ?? true;
      _autoAcceptRides = prefs.getBool('auto_accept_rides') ?? false;
      _showEarningsOnMap = prefs.getBool('show_earnings_on_map') ?? true;
      _navigationApp = prefs.getString('navigation_app') ?? 'Google Maps';
      _language = prefs.getString('language') ?? 'English';
      _acceptanceRadius = prefs.getDouble('acceptance_radius') ?? 5.0;
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    }
    _showSnackBar('Setting saved successfully');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

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
          'Settings',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSection('Notifications', [
            _buildSwitchTile(
              'Push Notifications',
              'Receive ride requests and updates',
              Icons.notifications_active,
              Colors.blue,
              _pushNotifications,
              (value) {
                setState(() => _pushNotifications = value);
                _saveSetting('push_notifications', value);
              },
            ),
            _buildSwitchTile(
              'Sound Effects',
              'Play sounds for new ride requests',
              Icons.volume_up,
              Colors.orange,
              _soundEffects,
              (value) {
                setState(() => _soundEffects = value);
                _saveSetting('sound_effects', value);
              },
            ),
          ]),
          SizedBox(height: 16),
          _buildSection('Ride Preferences', [
            _buildSwitchTile(
              'Auto-Accept Rides',
              'Automatically accept nearby ride requests',
              Icons.auto_awesome,
              Colors.purple,
              _autoAcceptRides,
              (value) {
                setState(() => _autoAcceptRides = value);
                _saveSetting('auto_accept_rides', value);
              },
            ),
            _buildSwitchTile(
              'Show Earnings on Map',
              'Display potential earnings on ride requests',
              Icons.attach_money,
              Colors.green,
              _showEarningsOnMap,
              (value) {
                setState(() => _showEarningsOnMap = value);
                _saveSetting('show_earnings_on_map', value);
              },
            ),
            _buildSliderTile(
              'Acceptance Radius',
              'Maximum distance for ride requests (${_acceptanceRadius.toStringAsFixed(1)} km)',
              Icons.radar,
              Colors.red,
              _acceptanceRadius,
              1.0,
              20.0,
              (value) {
                setState(() => _acceptanceRadius = value);
                _saveSetting('acceptance_radius', value);
              },
            ),
          ]),
          SizedBox(height: 16),
          _buildSection('Navigation', [
            _buildDropdownTile(
              'Navigation App',
              'Default app for navigation',
              Icons.navigation,
              Colors.teal,
              _navigationApp,
              ['Google Maps', 'Waze', 'Apple Maps', 'In-App Navigation'],
              (value) {
                setState(() => _navigationApp = value!);
                _saveSetting('navigation_app', value);
              },
            ),
          ]),
          SizedBox(height: 16),
          _buildSection('App Settings', [
            _buildDropdownTile(
              'Language',
              'App display language',
              Icons.language,
              Colors.indigo,
              _language,
              ['English', 'Nepali', 'Hindi', 'Spanish'],
              (value) {
                setState(() => _language = value!);
                _saveSetting('language', value);
              },
            ),
            _buildActionTile(
              'Clear Cache',
              'Free up storage space',
              Icons.cleaning_services,
              Colors.amber,
              () {
                _showSnackBar('Cache cleared successfully');
              },
            ),
            _buildActionTile(
              'Reset to Default',
              'Reset all settings to default values',
              Icons.restore,
              Colors.red,
              () {
                _showResetDialog();
              },
            ),
          ]),
          SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
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
          Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon,
      Color color, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.green[700],
      ),
    );
  }

  Widget _buildSliderTile(String title, String subtitle, IconData icon,
      Color color, double value, double min, double max, Function(double) onChanged) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          subtitle: Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(72, 0, 20, 12),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: ((max - min) * 2).toInt(),
            activeColor: color,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownTile(String title, String subtitle, IconData icon,
      Color color, String value, List<String> items, Function(String?) onChanged) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
      trailing: DropdownButton<String>(
        value: value,
        underline: SizedBox(),
        items: items.map((item) {
          return DropdownMenuItem(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionTile(
      String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Settings'),
        content: Text('Are you sure you want to reset all settings to default values?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              await _loadSettings();
              Navigator.pop(context);
              _showSnackBar('Settings reset successfully');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }
}
