import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/user_service.dart';

/// User Provider
///
/// Manages user state and operations using ChangeNotifier.
class UserProvider with ChangeNotifier {
  final UserService _userService;

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserProvider({UserService? userService})
      : _userService = userService ?? UserService();

  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasUser => _user != null;

  /// Set user data
  void setUser(UserModel user) {
    _user = user;
    _error = null;
    notifyListeners();
  }

  /// Clear user data
  void clearUser() {
    _user = null;
    _error = null;
    notifyListeners();
  }

  /// Get user profile
  Future<void> getProfile() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _user = await _userService.getProfile();
      _error = null;
    } on ApiException catch (e) {
      _error = e.userMessage;
    } catch (e) {
      _error = 'Failed to load profile. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? name,
    String? cpf,
    String? phone,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _user = await _userService.updateProfile(
        name: name,
        cpf: cpf,
        phone: phone,
      );
      _error = null;
      return true;
    } on ApiException catch (e) {
      _error = e.userMessage;
      return false;
    } catch (e) {
      _error = 'Failed to update profile. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update user password
  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _userService.updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      _error = null;
      return true;
    } on ApiException catch (e) {
      _error = e.userMessage;
      return false;
    } catch (e) {
      _error = 'Failed to update password. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Upload user avatar
  Future<bool> uploadAvatar(String filePath) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final avatarUrl = await _userService.uploadAvatar(filePath);
      if (_user != null) {
        _user = _user!.copyWith(avatar: avatarUrl);
      }
      _error = null;
      return true;
    } on ApiException catch (e) {
      _error = e.userMessage;
      return false;
    } catch (e) {
      _error = 'Failed to upload avatar. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete user account
  Future<bool> deleteAccount() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _userService.deleteAccount();
      _user = null;
      _error = null;
      return true;
    } on ApiException catch (e) {
      _error = e.userMessage;
      return false;
    } catch (e) {
      _error = 'Failed to delete account. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
