import 'package:dio/dio.dart';
import '../config/api_config.dart';

/// Base API Service
///
/// Provides a configured Dio instance and common HTTP methods
/// with error handling and token interceptor.
class ApiService {
  late final Dio _dio;
  String? _authToken;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(milliseconds: ApiConfig.connectionTimeout),
        receiveTimeout: const Duration(milliseconds: ApiConfig.receiveTimeout),
        sendTimeout: const Duration(milliseconds: ApiConfig.sendTimeout),
        headers: ApiConfig.defaultHeaders,
        validateStatus: (status) {
          // Accept all status codes to handle them manually
          return status != null && status < 500;
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token to headers if available
          if (_authToken != null) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          // Handle errors globally
          return handler.next(error);
        },
      ),
    );
  }

  /// Set authentication token
  void setAuthToken(String? token) {
    _authToken = token;
  }

  /// Get authentication token
  String? get authToken => _authToken;

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle Dio errors and convert to ApiException
  ApiException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Connection timeout. Please check your internet connection.',
          statusCode: 0,
          type: ApiExceptionType.timeout,
        );
      case DioExceptionType.badResponse:
        return _handleResponseError(error);
      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request cancelled',
          statusCode: 0,
          type: ApiExceptionType.cancel,
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'No internet connection. Please check your network.',
          statusCode: 0,
          type: ApiExceptionType.network,
        );
      default:
        return ApiException(
          message: 'An unexpected error occurred: ${error.message}',
          statusCode: 0,
          type: ApiExceptionType.unknown,
        );
    }
  }

  /// Handle response errors (400-499)
  ApiException _handleResponseError(DioException error) {
    final statusCode = error.response?.statusCode ?? 0;
    final data = error.response?.data;

    String message = 'An error occurred';
    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ?? message;
    }

    ApiExceptionType type;
    switch (statusCode) {
      case 400:
        type = ApiExceptionType.badRequest;
        break;
      case 401:
        type = ApiExceptionType.unauthorized;
        message = 'Unauthorized. Please login again.';
        break;
      case 403:
        type = ApiExceptionType.forbidden;
        message = 'Access forbidden.';
        break;
      case 404:
        type = ApiExceptionType.notFound;
        message = 'Resource not found.';
        break;
      case 409:
        type = ApiExceptionType.conflict;
        break;
      case 422:
        type = ApiExceptionType.validationError;
        break;
      default:
        type = ApiExceptionType.serverError;
        message = 'Server error. Please try again later.';
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      type: type,
      data: data,
    );
  }
}

/// API Exception
///
/// Custom exception for API errors with detailed information.
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final ApiExceptionType type;
  final dynamic data;

  ApiException({
    required this.message,
    required this.statusCode,
    required this.type,
    this.data,
  });

  @override
  String toString() {
    return 'ApiException(message: $message, statusCode: $statusCode, type: $type)';
  }

  /// Get user-friendly error message
  String get userMessage {
    switch (type) {
      case ApiExceptionType.network:
        return 'No internet connection. Please check your network.';
      case ApiExceptionType.timeout:
        return 'Connection timeout. Please try again.';
      case ApiExceptionType.unauthorized:
        return 'Your session has expired. Please login again.';
      case ApiExceptionType.forbidden:
        return 'You do not have permission to access this resource.';
      case ApiExceptionType.notFound:
        return 'The requested resource was not found.';
      case ApiExceptionType.validationError:
        return message;
      case ApiExceptionType.conflict:
        return message;
      case ApiExceptionType.badRequest:
        return message;
      case ApiExceptionType.serverError:
        return 'Server error. Please try again later.';
      default:
        return message;
    }
  }

  /// Get validation errors if available
  List<String>? get validationErrors {
    if (data is Map<String, dynamic>) {
      final errors = data['errors'];
      if (errors is List) {
        return errors
            .map((e) => e is Map<String, dynamic> ? e['msg'] as String? : null)
            .whereType<String>()
            .toList();
      }
    }
    return null;
  }
}

/// API Exception Type
enum ApiExceptionType {
  network,
  timeout,
  cancel,
  unauthorized,
  forbidden,
  notFound,
  validationError,
  conflict,
  badRequest,
  serverError,
  unknown,
}
