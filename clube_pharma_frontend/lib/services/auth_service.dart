import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';
import '../config/api_endpoints.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';
import 'api_service.dart';

/// Authentication Service
///
/// Handles all authentication operations including login, register,
/// logout, and token management.
class AuthService {
  final ApiService _apiService;
  final FlutterSecureStorage _secureStorage;

  AuthService({
    ApiService? apiService,
    FlutterSecureStorage? secureStorage,
  })  : _apiService = apiService ?? ApiService(),
        _secureStorage = secureStorage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
            );

  /// Register a new user
  ///
  /// Parameters:
  /// - [email]: User's email address
  /// - [password]: User's password
  /// - [name]: User's full name
  /// - [cpf]: Optional - User's CPF (11 digits)
  /// - [phone]: Optional - User's phone (10-11 digits)
  /// - [planType]: Optional - Plan type (BASIC or FAMILY), defaults to BASIC
  ///
  /// Returns [AuthResponse] with user data and token on success
  /// Throws [ApiException] on error
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String name,
    String? cpf,
    String? phone,
    String? planType,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.authRegister,
      data: {
        'email': email,
        'password': password,
        'name': name,
        if (cpf != null) 'cpf': cpf,
        if (phone != null) 'phone': phone,
        if (planType != null) 'planType': planType,
      },
    );

    final authResponse = AuthResponse.fromJson(response.data as Map<String, dynamic>);

    if (authResponse.success && authResponse.data != null) {
      // Save token and user data
      await _saveAuthData(
        authResponse.data!.token,
        authResponse.data!.user,
      );

      // Set token in API service
      _apiService.setAuthToken(authResponse.data!.token);
    }

    return authResponse;
  }

  /// Login user
  ///
  /// Parameters:
  /// - [email]: User's email address
  /// - [password]: User's password
  ///
  /// Returns [AuthResponse] with user data and token on success
  /// Throws [ApiException] on error
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.authLogin,
      data: {
        'email': email,
        'password': password,
      },
    );

    final authResponse = AuthResponse.fromJson(response.data as Map<String, dynamic>);

    if (authResponse.success && authResponse.data != null) {
      // Save token and user data
      await _saveAuthData(
        authResponse.data!.token,
        authResponse.data!.user,
      );

      // Set token in API service
      _apiService.setAuthToken(authResponse.data!.token);
    }

    return authResponse;
  }

  /// Logout user
  ///
  /// Clears stored token and user data
  Future<void> logout() async {
    await _secureStorage.delete(key: ApiConfig.tokenKey);
    await _secureStorage.delete(key: ApiConfig.userKey);
    _apiService.setAuthToken(null);
  }

  /// Get current authenticated user
  ///
  /// Fetches fresh user data from the backend
  /// Returns [UserModel] on success
  /// Throws [ApiException] on error
  Future<UserModel> getCurrentUser() async {
    final response = await _apiService.get(ApiEndpoints.authMe);

    final userResponse = UserResponse.fromJson(response.data as Map<String, dynamic>);

    if (userResponse.success && userResponse.data != null) {
      // Update stored user data
      await _saveUserData(userResponse.data!.user);
      return userResponse.data!.user;
    } else {
      throw Exception(userResponse.message ?? 'Failed to get user data');
    }
  }

  /// Check if user is authenticated
  ///
  /// Returns true if valid token exists, false otherwise
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    if (token == null) return false;

    // Set token in API service
    _apiService.setAuthToken(token);

    // Try to get current user to verify token is valid
    try {
      await getCurrentUser();
      return true;
    } catch (e) {
      // Token is invalid, clear stored data
      await logout();
      return false;
    }
  }

  /// Get stored authentication token
  ///
  /// Returns token string if exists, null otherwise
  Future<String?> getToken() async {
    return await _secureStorage.read(key: ApiConfig.tokenKey);
  }

  /// Get stored user data
  ///
  /// Returns [UserModel] if exists, null otherwise
  Future<UserModel?> getStoredUser() async {
    final userJson = await _secureStorage.read(key: ApiConfig.userKey);
    if (userJson == null) return null;

    try {
      final userMap = json.decode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      // Invalid user data, clear it
      await _secureStorage.delete(key: ApiConfig.userKey);
      return null;
    }
  }

  /// Request password reset
  ///
  /// Sends a password reset email to the user
  /// Parameters:
  /// - [email]: User's email address
  ///
  /// Returns success message
  /// Throws [ApiException] on error
  Future<String> forgotPassword({required String email}) async {
    final response = await _apiService.post(
      ApiEndpoints.authForgotPassword,
      data: {'email': email},
    );

    final data = response.data as Map<String, dynamic>;
    return data['message'] as String? ?? 'Password reset email sent';
  }

  /// Reset password with token
  ///
  /// Parameters:
  /// - [token]: Reset token from email
  /// - [newPassword]: New password
  ///
  /// Returns success message
  /// Throws [ApiException] on error
  Future<String> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.authResetPassword,
      data: {
        'token': token,
        'newPassword': newPassword,
      },
    );

    final data = response.data as Map<String, dynamic>;
    return data['message'] as String? ?? 'Password reset successful';
  }

  /// Save authentication data (token and user)
  Future<void> _saveAuthData(String token, UserModel user) async {
    await _secureStorage.write(key: ApiConfig.tokenKey, value: token);
    await _saveUserData(user);
  }

  /// Save user data
  Future<void> _saveUserData(UserModel user) async {
    final userJson = json.encode(user.toJson());
    await _secureStorage.write(key: ApiConfig.userKey, value: userJson);
  }
}
