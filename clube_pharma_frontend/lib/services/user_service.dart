import '../config/api_endpoints.dart';
import '../models/user_model.dart';
import 'api_service.dart';

/// User Service
///
/// Handles user profile operations including get, update, password change, and avatar upload.
class UserService {
  final ApiService _apiService;

  UserService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Get user profile
  ///
  /// Fetches the current user's profile data
  /// Returns [UserModel] on success
  /// Throws [ApiException] on error
  Future<UserModel> getProfile() async {
    try {
      final response = await _apiService.get(ApiEndpoints.userProfile);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return UserModel.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        throw Exception('Failed to get profile');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Update user profile
  ///
  /// Parameters:
  /// - [name]: User's full name
  /// - [cpf]: Optional - User's CPF
  /// - [phone]: Optional - User's phone
  ///
  /// Returns updated [UserModel] on success
  /// Throws [ApiException] on error
  Future<UserModel> updateProfile({
    String? name,
    String? cpf,
    String? phone,
  }) async {
    try {
      final response = await _apiService.put(
        ApiEndpoints.userUpdateProfile,
        data: {
          if (name != null) 'name': name,
          if (cpf != null) 'cpf': cpf,
          if (phone != null) 'phone': phone,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return UserModel.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Update user password
  ///
  /// Parameters:
  /// - [currentPassword]: Current password
  /// - [newPassword]: New password
  ///
  /// Returns success message
  /// Throws [ApiException] on error
  Future<String> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.put(
        ApiEndpoints.userUpdatePassword,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['message'] as String? ?? 'Password updated successfully';
      } else {
        throw Exception('Failed to update password');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Upload user avatar
  ///
  /// Parameters:
  /// - [filePath]: Local path to the image file
  ///
  /// Returns URL of uploaded avatar
  /// Throws [ApiException] on error
  Future<String> uploadAvatar(String filePath) async {
    try {
      // TODO: Implement multipart file upload
      // For now, returning a placeholder
      throw UnimplementedError('Avatar upload not yet implemented');
    } catch (e) {
      rethrow;
    }
  }

  /// Delete user account
  ///
  /// Permanently deletes the user's account
  /// Returns success message
  /// Throws [ApiException] on error
  Future<String> deleteAccount() async {
    try {
      final response = await _apiService.delete(ApiEndpoints.userDeleteAccount);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['message'] as String? ?? 'Account deleted successfully';
      } else {
        throw Exception('Failed to delete account');
      }
    } catch (e) {
      rethrow;
    }
  }
}
