import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../services/socket_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final SocketService _socketService = SocketService();
  
  String? _token;
  Map<String, dynamic>? _user;
  bool _isAuthenticated = false;
  String _userType = 'rider'; // rider, driver, admin

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get user => _user;
  String? get token => _token;
  String get userType => _userType;
  
  bool get isRider => _userType == 'rider';
  bool get isDriver => _userType == 'driver';
  bool get isAdmin => _userType == 'admin';

  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');
      final userJson = prefs.getString('user_data');
      _userType = prefs.getString('user_type') ?? 'rider';
      
      if (_token != null && userJson != null) {
        _isAuthenticated = true;
        _socketService.connect(_token!);
        // Don't await loadUserProfile to avoid blocking initialization
        loadUserProfile().catchError((e) {
          developer.log('Failed to load user profile', error: e, name: 'AuthProvider');
        });
      }
      notifyListeners();
    } catch (e) {
      developer.log('Failed to initialize auth', error: e, name: 'AuthProvider');
      notifyListeners();
    }
  }

  Future<bool> sendOTP(String phone) async {
    try {
      await _apiService.sendOTP(phone);
      return true;
    } catch (e) {
      developer.log('Send OTP error', error: e, name: 'AuthProvider');
      return false;
    }
  }

  Future<bool> verifyOTP(String phone, String otp) async {
    try {
      final response = await _apiService.verifyOTP(phone, otp);
      _token = response['token'];
      _user = response['user'];
      _userType = response['user']['type'] ?? 'rider';
      _isAuthenticated = true;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      await prefs.setString('user_type', _userType);
      
      await _apiService.setAuthToken(_token!);
      _socketService.connect(_token!);
      
      notifyListeners();
      return true;
    } catch (e) {
      developer.log('Verify OTP error', error: e, name: 'AuthProvider');
      return false;
    }
  }
  
  Future<void> loadUserProfile() async {
    try {
      _user = await _apiService.getUserProfile();
      notifyListeners();
    } catch (e) {
      developer.log('Load profile error', error: e, name: 'AuthProvider');
    }
  }
  
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      _user = await _apiService.updateUserProfile(data);
      notifyListeners();
      return true;
    } catch (e) {
      developer.log('Update profile error', error: e, name: 'AuthProvider');
      return false;
    }
  }
  
  void switchUserType(String type) {
    _userType = type;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('user_type', type);
    });
    notifyListeners();
  }
  Future<void> logout() async {
    _socketService.disconnect();
    await _apiService.clearAuthToken();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    _token = null;
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
