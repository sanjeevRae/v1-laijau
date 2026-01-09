import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  
  late Dio _dio;
  String? _token;
  
  static const String baseUrl = 'http://localhost:8080/api';
  
  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
    
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        return handler.next(options);
      },
    ));
    
    _loadToken();
  }
  
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }
  
  Future<void> setAuthToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
  
  Future<void> clearAuthToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Auth APIs
  Future<Map<String, dynamic>> sendOTP(String phone) async {
    try {
      final response = await _dio.post('/auth/send-otp', data: {'phone': phone});
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> verifyOTP(String phone, String otp) async {
    try {
      final response = await _dio.post('/auth/verify-otp', data: {
        'phone': phone,
        'otp': otp,
      });
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Ride APIs
  Future<Map<String, dynamic>> requestRide(Map<String, dynamic> rideData) async {
    try {
      final response = await _dio.post('/rides/request', data: rideData);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getRideStatus(String rideId) async {
    try {
      final response = await _dio.get('/rides/$rideId');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getRideHistory() async {
    try {
      final response = await _dio.get('/rides/history');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _dio.get('/user/profile');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/user/profile', data: data);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Map<String, dynamic>> acceptRide(String rideId) async {
    try {
      final response = await _dio.post('/rides/$rideId/accept');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Map<String, dynamic>> startRide(String rideId) async {
    try {
      final response = await _dio.post('/rides/$rideId/start');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Map<String, dynamic>> completeRide(String rideId) async {
    try {
      final response = await _dio.post('/rides/$rideId/complete');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Map<String, dynamic>> estimateFare({
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
    required String vehicleType,
  }) async {
    try {
      final response = await _dio.post('/rides/estimate-fare', data: {
        'pickup': {'lat': pickupLat, 'lng': pickupLng},
        'drop': {'lat': dropLat, 'lng': dropLng},
        'vehicleType': vehicleType,
      });
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Map<String, dynamic>> rateRide(String rideId, double rating, String? comment) async {
    try {
      final response = await _dio.post('/rides/$rideId/rate', data: {
        'rating': rating,
        'comment': comment,
      });
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Map<String, dynamic>> getAdminDashboard() async {
    try {
      final response = await _dio.get('/admin/dashboard');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<List<dynamic>> getAllUsers({int page = 1, int limit = 50}) async {
    try {
      final response = await _dio.get('/admin/users', queryParameters: {
        'page': page,
        'limit': limit,
      });
      return response.data['users'];
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<List<dynamic>> getPendingDrivers() async {
    try {
      final response = await _dio.get('/admin/drivers/pending');
      return response.data['drivers'];
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Map<String, dynamic>> approveDriver(String driverId) async {
    try {
      final response = await _dio.post('/admin/drivers/$driverId/approve');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> cancelRide(String rideId) async {
    try {
      final response = await _dio.post('/rides/$rideId/cancel');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Location APIs
  Future<List<dynamic>> searchAddress(String query) async {
    try {
      final response = await _dio.get(
        'https://photon.komoot.io/api/',
        queryParameters: {'q': query, 'limit': 5},
      );
      return response.data['features'];
    } catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timeout. Please try again.';
        case DioExceptionType.badResponse:
          return error.response?.data['message'] ?? 'Server error occurred.';
        case DioExceptionType.cancel:
          return 'Request cancelled.';
        default:
          return 'Network error. Please check your connection.';
      }
    }
    return 'An unexpected error occurred.';
  }
}
