import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/splash_screen.dart';
import 'pages/login_page.dart';
import 'pages/user_type_selection.dart';
import 'pages/home.dart';
import 'pages/rider/rider_home.dart';
import 'pages/driver/driver_home.dart';
import 'pages/admin/admin_dashboard.dart';
import 'providers/auth_provider.dart';
import 'providers/location_provider.dart';
import 'providers/ride_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => LocationProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => RideProvider()..initialize()),
      ],
      child: MaterialApp(
        title: 'Laijau - Ride Sharing',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
          primaryColor: Colors.black,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginPage(),
          '/user-type-selection': (context) => const UserTypeSelection(),
          '/home': (context) => const HomePage(),
          '/rider': (context) => const RiderHome(),
          '/driver': (context) => const DriverHome(),
          '/admin': (context) => const AdminDashboard(),
        },
      ),
    );
  }
}
