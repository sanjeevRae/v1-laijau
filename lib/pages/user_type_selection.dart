import 'package:flutter/material.dart';

class UserTypeSelection extends StatefulWidget {
  const UserTypeSelection({super.key});

  @override
  State<UserTypeSelection> createState() => _UserTypeSelectionState();
}

class _UserTypeSelectionState extends State<UserTypeSelection> {
  String _selectedType = 'passenger'; // 'passenger' or 'rider'
  
  // Color constants
  static const Color primaryGreen = Color(0xFF00BF6D);
  static const Color lightGreen = Color(0xFFE8F8F2);
  static const Color darkGreen = Color(0xFF009D57);

  @override
  Widget build(BuildContext context) {
  return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          _handleBackPress(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => _handleBackPress(context),
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
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Select how you want to use Laijau',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 50),
              
              // Passenger Option
              GestureDetector(
                onTap: () => setState(() => _selectedType = 'passenger'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: _selectedType == 'passenger' 
                        ? const LinearGradient(
                            colors: [primaryGreen, darkGreen],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: _selectedType == 'passenger' 
                        ? null 
                        : lightGreen,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _selectedType == 'passenger' 
                          ? primaryGreen 
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                    boxShadow: _selectedType == 'passenger'
                        ? [
                            BoxShadow(
                              color: primaryGreen.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _selectedType == 'passenger'
                              ? Colors.white
                              : primaryGreen,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          size: 36,
                          color: _selectedType == 'passenger'
                              ? primaryGreen
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
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Request rides and travel comfortably',
                              style: TextStyle(
                                fontSize: 14,
                                color: _selectedType == 'passenger'
                                    ? Colors.white.withOpacity(0.9)
                                    : Colors.grey[700],
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _selectedType == 'passenger'
                                ? Colors.white
                                : Colors.grey[400]!,
                            width: 2,
                          ),
                          color: _selectedType == 'passenger'
                              ? Colors.white
                              : Colors.transparent,
                        ),
                        child: _selectedType == 'passenger'
                            ? const Icon(
                                Icons.check,
                                size: 18,
                                color: primaryGreen,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Rider/Driver Option
              GestureDetector(
                onTap: () => setState(() => _selectedType = 'rider'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: _selectedType == 'rider' 
                        ? const LinearGradient(
                            colors: [primaryGreen, darkGreen],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: _selectedType == 'rider' 
                        ? null 
                        : lightGreen,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _selectedType == 'rider' 
                          ? primaryGreen 
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                    boxShadow: _selectedType == 'rider'
                        ? [
                            BoxShadow(
                              color: primaryGreen.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _selectedType == 'rider'
                              ? Colors.white
                              : primaryGreen,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.directions_car_rounded,
                          size: 36,
                          color: _selectedType == 'rider'
                              ? primaryGreen
                              : Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Driver',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: _selectedType == 'rider'
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Offer rides and earn money',
                              style: TextStyle(
                                fontSize: 14,
                                color: _selectedType == 'rider'
                                    ? Colors.white.withOpacity(0.9)
                                    : Colors.grey[700],
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _selectedType == 'rider'
                                ? Colors.white
                                : Colors.grey[400]!,
                            width: 2,
                          ),
                          color: _selectedType == 'rider'
                              ? Colors.white
                              : Colors.transparent,
                        ),
                        child: _selectedType == 'rider'
                            ? const Icon(
                                Icons.check,
                                size: 18,
                                color: primaryGreen,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Continue Button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primaryGreen.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
        ),
      ),
    ),
  );
  }

  void _handleBackPress(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        alignment: Alignment.topCenter,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: lightGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: primaryGreen,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Choose Your Role',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Please select your role to continue using Laijau.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Exit the app
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(
                      'Go to Login',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Stay Here'),
                  ),
                ],
              ),
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
