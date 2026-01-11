import 'package:flutter/material.dart';

class UserTypeSelection extends StatefulWidget {
  const UserTypeSelection({super.key});

  @override
  State<UserTypeSelection> createState() => _UserTypeSelectionState();
}

class _UserTypeSelectionState extends State<UserTypeSelection> {
  String _selectedType = 'passenger'; // 'passenger' or 'rider'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Choose Your Role',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Select how you want to use Laijau',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 60),
              
              // Passenger Option
              GestureDetector(
                onTap: () => setState(() => _selectedType = 'passenger'),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _selectedType == 'passenger' 
                        ? Colors.black 
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _selectedType == 'passenger' 
                          ? Colors.black 
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _selectedType == 'passenger'
                              ? Colors.white
                              : Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 32,
                          color: _selectedType == 'passenger'
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Passenger',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: _selectedType == 'passenger'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Request rides and travel',
                              style: TextStyle(
                                fontSize: 14,
                                color: _selectedType == 'passenger'
                                    ? Colors.white70
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Radio<String>(
                        value: 'passenger',
                        groupValue: _selectedType,
                        onChanged: (value) {
                          setState(() => _selectedType = value!);
                        },
                        activeColor: Colors.white,
                        fillColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.white;
                          }
                          return Colors.grey;
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Rider/Driver Option
              GestureDetector(
                onTap: () => setState(() => _selectedType = 'rider'),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _selectedType == 'rider' 
                        ? Colors.black 
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _selectedType == 'rider' 
                          ? Colors.black 
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _selectedType == 'rider'
                              ? Colors.white
                              : Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.directions_car,
                          size: 32,
                          color: _selectedType == 'rider'
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rider',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: _selectedType == 'rider'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Offer rides and earn',
                              style: TextStyle(
                                fontSize: 14,
                                color: _selectedType == 'rider'
                                    ? Colors.white70
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Radio<String>(
                        value: 'rider',
                        groupValue: _selectedType,
                        onChanged: (value) {
                          setState(() => _selectedType = value!);
                        },
                        activeColor: Colors.white,
                        fillColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.white;
                          }
                          return Colors.grey;
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Continue Button
              ElevatedButton(
                onPressed: _continue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _continue() {
    // Navigate based on selected type
    if (_selectedType == 'passenger') {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/driver');
    }
  }
}
