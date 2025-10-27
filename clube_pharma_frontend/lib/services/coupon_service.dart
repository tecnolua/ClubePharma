import '../config/api_endpoints.dart';
import '../models/coupon_model.dart';
import 'api_service.dart';

/// Coupon Service
///
/// Handles coupon operations including validate, apply, and list.
class CouponService {
  final ApiService _apiService;

  CouponService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Get all available coupons
  ///
  /// Returns list of [CouponModel]
  /// Throws [ApiException] on error
  Future<List<CouponModel>> getCoupons() async {
    try {
      final response = await _apiService.get(ApiEndpoints.couponsList);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final couponsList = data['data'] as List;
        return couponsList
            .map((json) => CouponModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to get coupons');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get coupon by ID
  ///
  /// Parameters:
  /// - [id]: Coupon ID
  ///
  /// Returns [CouponModel]
  /// Throws [ApiException] on error
  Future<CouponModel> getCouponById(String id) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.couponsGetById(id),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return CouponModel.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        throw Exception('Failed to get coupon');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Validate coupon code
  ///
  /// Parameters:
  /// - [code]: Coupon code to validate
  /// - [cartTotal]: Optional - Cart total to validate minimum purchase
  ///
  /// Returns [CouponModel] with validation status
  /// Throws [ApiException] on error
  Future<CouponModel> validateCoupon({
    required String code,
    double? cartTotal,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.couponsValidate,
        data: {
          'code': code,
          if (cartTotal != null) 'cartTotal': cartTotal,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return CouponModel.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        throw Exception('Failed to validate coupon');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Apply coupon to cart
  ///
  /// Parameters:
  /// - [code]: Coupon code to apply
  ///
  /// Returns applied [CouponModel] with discount info
  /// Throws [ApiException] on error
  Future<Map<String, dynamic>> applyCoupon(String code) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.couponsApply,
        data: {'code': code},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['data'] as Map<String, dynamic>;
      } else {
        throw Exception('Failed to apply coupon');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Remove coupon from cart
  ///
  /// Parameters:
  /// - [code]: Coupon code to remove
  ///
  /// Returns success message
  /// Throws [ApiException] on error
  Future<String> removeCoupon(String code) async {
    try {
      final response = await _apiService.delete(
        ApiEndpoints.couponsRemove(code),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['message'] as String? ?? 'Coupon removed successfully';
      } else {
        throw Exception('Failed to remove coupon');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Calculate discount amount
  ///
  /// Helper method to calculate discount based on coupon type
  ///
  /// Parameters:
  /// - [coupon]: CouponModel
  /// - [cartTotal]: Cart total amount
  ///
  /// Returns discount amount
  double calculateDiscount({
    required CouponModel coupon,
    required double cartTotal,
  }) {
    return coupon.calculateDiscount(cartTotal);
  }
}
