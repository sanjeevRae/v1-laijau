import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'pages/welcome_screen.dart';
import 'pages/splash_screen.dart';
// import your new login and otp screens here if needed
import 'pages/login.dart';
import 'pages/otp.dart';
import 'pages/user_type_selection.dart';
import 'pages/home.dart';
import 'pages/rider/rider_home.dart';
import 'pages/driver/driver_home.dart';
import 'pages/admin/admin_dashboard.dart';
import 'pages/error_404.dart';
import 'providers/auth_provider.dart';
import 'providers/location_provider.dart';
import 'providers/ride_provider.dart';
import 'dart:developer' as developer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global error handlers to prevent app crashes
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    developer.log(
      'Flutter Error',
      error: details.exception,
      stackTrace: details.stack,
      name: 'GlobalErrorHandler',
    );
  };

  // Catch errors in async operations
  runZonedGuarded(
    () {
      runApp(const MyApp());
    },
    (error, stack) {
      developer.log(
        'Uncaught Error',
        error: error,
        stackTrace: stack,
        name: 'GlobalErrorHandler',
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final provider = AuthProvider();
            // Initialize asynchronously without blocking
            provider.initialize().catchError((e) {
              // Silently handle errors during initialization
            });
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final provider = LocationProvider();
            // Initialize asynchronously without blocking
            provider.initialize().catchError((e) {
              // Silently handle errors during initialization
              return false;
            });
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final provider = RideProvider();
            try {
              provider.initialize();
            } catch (e) {
              // Silently handle errors during initialization
            }
            return provider;
          },
        ),
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
        onUnknownRoute: (settings) {
          // Handle unknown routes gracefully - show 404 page
          return MaterialPageRoute(builder: (context) => const Error404Screen());
        },
        builder: (context, widget) {
          // Global error handling for widget tree
          ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red[300],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Oops! Something went wrong',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Please restart the app',
                        style: TextStyle(color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          };
          return widget!;
        },
        routes: {
          '/': (context) => const SplashScreen(),
          '/welcome': (context) => const WelcomeScreen(),
          // Add your new login, OTP, and other screens here as needed
          '/login': (context) => Login(),
          '/otp': (context) => const VerificationScreen(),
          '/user-type-selection': (context) => const UserTypeSelection(),
          '/home': (context) => const HomePage(),
          '/rider': (context) => const RiderHome(),
          '/driver': (context) => const DriverHome(),
          '/admin': (context) => const AdminDashboard(),
          '/404': (context) => const Error404Screen(),
        },
      ),
    );
  }
}
