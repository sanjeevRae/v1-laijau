class AppConfig {
  // Change this to your actual backend server IP address
  // For local testing: Use your computer's local network IP (e.g., 192.168.1.100)
  // For production: Use your deployed server URL
  static const String baseUrl = 'http://192.168.1.100:8080';
  
  // API endpoint
  static const String apiUrl = '$baseUrl/api';
  
  // Socket endpoint
  static const String socketUrl = baseUrl;
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  
  // Feature flags
  static const bool enableSocketConnection = false; // Set to true when backend is ready
  static const bool enableApiCalls = false; // Set to true when backend is ready
  
  // Debug mode
  static const bool debugMode = true;
}
