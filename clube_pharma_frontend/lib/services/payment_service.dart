import '../config/api_endpoints.dart';
import '../models/payment_model.dart';
import 'api_service.dart';

/// Payment Service
///
/// Handles payment operations including create preference, get status, and payment history.
class PaymentService {
  final ApiService _apiService;

  PaymentService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Create payment preference (Mercado Pago)
  ///
  /// Parameters:
  /// - [orderId]: Order ID to create payment for
  /// - [amount]: Payment amount
  /// - [description]: Payment description
  ///
  /// Returns payment preference URL and ID
  /// Throws [ApiException] on error
  Future<Map<String, dynamic>> createPaymentPreference({
    required String orderId,
    required double amount,
    required String description,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.paymentsCreatePreference,
        data: {
          'orderId': orderId,
          'amount': amount,
          'description': description,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['data'] as Map<String, dynamic>;
      } else {
        throw Exception('Failed to create payment preference');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get payment by ID
  ///
  /// Parameters:
  /// - [id]: Payment ID
  ///
  /// Returns [PaymentModel]
  /// Throws [ApiException] on error
  Future<PaymentModel> getPaymentById(String id) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.paymentsGetById(id),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return PaymentModel.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        throw Exception('Failed to get payment');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get payment status
  ///
  /// Parameters:
  /// - [id]: Payment ID
  ///
  /// Returns payment status string
  /// Throws [ApiException] on error
  Future<String> getPaymentStatus(String id) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.paymentsStatus(id),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['status'] as String;
      } else {
        throw Exception('Failed to get payment status');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get payment history
  ///
  /// Parameters:
  /// - [limit]: Optional - Number of results to return
  /// - [offset]: Optional - Number of results to skip
  ///
  /// Returns list of [PaymentModel]
  /// Throws [ApiException] on error
  Future<List<PaymentModel>> getPaymentHistory({
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response = await _apiService.get(
        ApiEndpoints.paymentsHistory,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final paymentsList = data['data'] as List;
        return paymentsList
            .map((json) => PaymentModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to get payment history');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get all payments
  ///
  /// Returns list of all [PaymentModel]
  /// Throws [ApiException] on error
  Future<List<PaymentModel>> getPayments() async {
    try {
      final response = await _apiService.get(ApiEndpoints.paymentsList);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final paymentsList = data['data'] as List;
        return paymentsList
            .map((json) => PaymentModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to get payments');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Request payment refund
  ///
  /// Parameters:
  /// - [id]: Payment ID
  /// - [reason]: Optional - Refund reason
  ///
  /// Returns success message
  /// Throws [ApiException] on error
  Future<String> refundPayment(String id, {String? reason}) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.paymentsRefund(id),
        data: {
          if (reason != null) 'reason': reason,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['message'] as String? ?? 'Refund requested successfully';
      } else {
        throw Exception('Failed to request refund');
      }
    } catch (e) {
      rethrow;
    }
  }
}
