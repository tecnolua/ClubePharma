import 'user_model.dart';

/// Authentication Response Model
///
/// Represents the response from authentication endpoints
/// (login and register).
class AuthResponse {
  final bool success;
  final String message;
  final AuthData? data;
  final List<ValidationError>? errors;

  AuthResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  /// Create AuthResponse from JSON
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? AuthData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      errors: json['errors'] != null
          ? (json['errors'] as List)
              .map((e) => ValidationError.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  /// Convert AuthResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'errors': errors?.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'AuthResponse(success: $success, message: $message)';
  }
}

/// Authentication Data
///
/// Contains user and token information from auth responses.
class AuthData {
  final UserModel user;
  final String token;

  AuthData({
    required this.user,
    required this.token,
  });

  /// Create AuthData from JSON
  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
    );
  }

  /// Convert AuthData to JSON
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
    };
  }

  @override
  String toString() {
    return 'AuthData(user: ${user.email}, token: ${token.substring(0, 20)}...)';
  }
}

/// Validation Error
///
/// Represents a validation error from the backend.
class ValidationError {
  final String? type;
  final String? value;
  final String msg;
  final String? path;
  final String? location;

  ValidationError({
    this.type,
    this.value,
    required this.msg,
    this.path,
    this.location,
  });

  /// Create ValidationError from JSON
  factory ValidationError.fromJson(Map<String, dynamic> json) {
    return ValidationError(
      type: json['type'] as String?,
      value: json['value'] as String?,
      msg: json['msg'] as String? ?? json['message'] as String? ?? 'Validation error',
      path: json['path'] as String?,
      location: json['location'] as String?,
    );
  }

  /// Convert ValidationError to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
      'msg': msg,
      'path': path,
      'location': location,
    };
  }

  @override
  String toString() {
    return 'ValidationError(path: $path, msg: $msg)';
  }
}

/// User Response Model
///
/// Represents the response from the /me endpoint.
class UserResponse {
  final bool success;
  final UserData? data;
  final String? message;

  UserResponse({
    required this.success,
    this.data,
    this.message,
  });

  /// Create UserResponse from JSON
  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null
          ? UserData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
    );
  }

  /// Convert UserResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
      'message': message,
    };
  }
}

/// User Data
///
/// Contains user information from /me endpoint.
class UserData {
  final UserModel user;

  UserData({required this.user});

  /// Create UserData from JSON
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  /// Convert UserData to JSON
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
    };
  }
}
