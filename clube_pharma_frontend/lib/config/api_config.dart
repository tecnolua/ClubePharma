/// API Configuration
///
/// Contains all API-related configuration including base URL,
/// timeout settings, headers, and all 91 endpoints across 14 modules.
class ApiConfig {
  // Base URLs
  static const String baseUrl = 'http://localhost:3000';
  static const String baseUrlProd = 'https://api.clubepharma.com'; // for future production

  // Current base URL (change to baseUrlProd for production)
  static String get currentBaseUrl => baseUrl;

  // API prefix
  static const String apiPrefix = '/api';

  // Module endpoints (14 modules)
  static const String auth = '$apiPrefix/auth';
  static const String users = '$apiPrefix/users';
  static const String familyMembers = '$apiPrefix/family-members';
  static const String treatments = '$apiPrefix/treatments';
  static const String pillTakes = '$apiPrefix/pill-takes';
  static const String prescriptions = '$apiPrefix/prescriptions';
  static const String exams = '$apiPrefix/exams';
  static const String products = '$apiPrefix/products';
  static const String cart = '$apiPrefix/cart';
  static const String orders = '$apiPrefix/orders';
  static const String doctors = '$apiPrefix/doctors';
  static const String appointments = '$apiPrefix/appointments';
  static const String payments = '$apiPrefix/payments';
  static const String coupons = '$apiPrefix/coupons';
  static const String dashboard = '$apiPrefix/dashboard';

  // Timeout settings (in milliseconds)
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds

  // Headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> getAuthHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };

  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String refreshTokenKey = 'refresh_token';
}
