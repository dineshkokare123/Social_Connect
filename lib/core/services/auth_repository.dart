import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../constants/api_constants.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  // Login
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // Save token
        if (data['token'] != null) {
          _apiService.setAuthToken(data['token']);
        }
        return data;
      }
      return null;
    } catch (e) {
      debugPrint('Error logging in: $e');
      return null;
    }
  }

  // Register
  Future<Map<String, dynamic>?> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await _apiService.post(
        ApiConstants.register,
        data: {'name': name, 'email': email, 'password': password},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        // Save token
        if (data['token'] != null) {
          _apiService.setAuthToken(data['token']);
        }
        return data;
      }
      return null;
    } catch (e) {
      debugPrint('Error registering: $e');
      return null;
    }
  }

  // Logout
  Future<bool> logout() async {
    try {
      final response = await _apiService.post(ApiConstants.logout);
      _apiService.clearAuthToken();
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error logging out: $e');
      _apiService.clearAuthToken();
      return false;
    }
  }

  // Refresh token
  Future<String?> refreshToken(String refreshToken) async {
    try {
      final response = await _apiService.post(
        ApiConstants.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newToken = response.data['token'];
        _apiService.setAuthToken(newToken);
        return newToken;
      }
      return null;
    } catch (e) {
      debugPrint('Error refreshing token: $e');
      return null;
    }
  }
}
