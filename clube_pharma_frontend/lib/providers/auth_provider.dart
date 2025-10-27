import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

/// Authentication Provider
///
/// Manages authentication state using Provider pattern.
/// Handles login, register, logout, and auto-login functionality.
class AuthProvider with ChangeNotifier {
  final AuthService _authService;

  UserModel? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService();

  /// Current user
  UserModel? get user => _user;

  /// Loading state
  bool get isLoading => _isLoading;

  /// Authentication state
  bool get isAuthenticated => _isAuthenticated;

  /// Error message
  String? get errorMessage => _errorMessage;

  /// Initialize authentication
  ///
  /// Checks if user is already authenticated and loads user data
  /// Should be called on app startup
  Future<void> initialize() async {
    _setLoading(true);
    _clearError();

    try {
      // Check if token exists and is valid
      final isAuth = await _authService.isAuthenticated();

      if (isAuth) {
        // Load stored user data
        final storedUser = await _authService.getStoredUser();
        if (storedUser != null) {
          _user = storedUser;
          _isAuthenticated = true;
        }
      }
    } catch (e) {
      debugPrint('Initialize auth error: $e');
      _isAuthenticated = false;
      _user = null;
    } finally {
      _setLoading(false);
    }
  }

  /// Login user
  ///
  /// Parameters:
  /// - [email]: User's email address
  /// - [password]: User's password
  ///
  /// Returns true on success, false on error
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      if (response.success && response.data != null) {
        _user = response.data!.user;
        _isAuthenticated = true;
        _setLoading(false);
        return true;
      } else {
        _setError(response.message);
        _setLoading(false);
        return false;
      }
    } on ApiException catch (e) {
      _setError(e.userMessage);
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
      debugPrint('Login error: $e');
      _setLoading(false);
      return false;
    }
  }

  /// Register new user
  ///
  /// Parameters:
  /// - [email]: User's email address
  /// - [password]: User's password
  /// - [name]: User's full name
  /// - [cpf]: Optional - User's CPF
  /// - [phone]: Optional - User's phone
  /// - [planType]: Optional - Plan type
  ///
  /// Returns true on success, false on error
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    String? cpf,
    String? phone,
    String? planType,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _authService.register(
        email: email,
        password: password,
        name: name,
        cpf: cpf,
        phone: phone,
        planType: planType,
      );

      if (response.success && response.data != null) {
        _user = response.data!.user;
        _isAuthenticated = true;
        _setLoading(false);
        return true;
      } else {
        // Handle validation errors
        if (response.errors != null && response.errors!.isNotEmpty) {
          _setError(response.errors!.first.msg);
        } else {
          _setError(response.message);
        }
        _setLoading(false);
        return false;
      }
    } on ApiException catch (e) {
      // Check for validation errors
      final validationErrors = e.validationErrors;
      if (validationErrors != null && validationErrors.isNotEmpty) {
        _setError(validationErrors.first);
      } else {
        _setError(e.userMessage);
      }
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
      debugPrint('Register error: $e');
      _setLoading(false);
      return false;
    }
  }

  /// Logout user
  ///
  /// Clears user data and authentication state
  Future<void> logout() async {
    _setLoading(true);

    try {
      await _authService.logout();
      _user = null;
      _isAuthenticated = false;
      _clearError();
    } catch (e) {
      debugPrint('Logout error: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh current user data
  ///
  /// Fetches latest user data from backend
  /// Returns true on success, false on error
  Future<bool> refreshUser() async {
    if (!_isAuthenticated) return false;

    try {
      final user = await _authService.getCurrentUser();
      _user = user;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Refresh user error: $e');
      return false;
    }
  }

  /// Request password reset
  ///
  /// Parameters:
  /// - [email]: User's email address
  ///
  /// Returns true on success, false on error
  Future<bool> forgotPassword({required String email}) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.forgotPassword(email: email);
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _setError(e.userMessage);
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
      debugPrint('Forgot password error: $e');
      _setLoading(false);
      return false;
    }
  }

  /// Reset password with token
  ///
  /// Parameters:
  /// - [token]: Reset token from email
  /// - [newPassword]: New password
  ///
  /// Returns true on success, false on error
  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _setError(e.userMessage);
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
      debugPrint('Reset password error: $e');
      _setLoading(false);
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _clearError();
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Clear error message
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
