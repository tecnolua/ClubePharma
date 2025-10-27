/// Payment Model
///
/// Represents a payment in the ClubePharma system.
class PaymentModel {
  final String id;
  final String userId;
  final String? orderId;
  final String? appointmentId;
  final double amount;
  final String method; // CREDIT_CARD, DEBIT_CARD, PIX, BOLETO
  final String status; // PENDING, APPROVED, REJECTED, REFUNDED
  final String? transactionId;
  final String? paymentUrl;
  final DateTime? paidAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentModel({
    required this.id,
    required this.userId,
    this.orderId,
    this.appointmentId,
    required this.amount,
    required this.method,
    required this.status,
    this.transactionId,
    this.paymentUrl,
    this.paidAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create PaymentModel from JSON
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      orderId: json['orderId'] as String?,
      appointmentId: json['appointmentId'] as String?,
      amount: (json['amount'] as num).toDouble(),
      method: json['method'] as String,
      status: json['status'] as String,
      transactionId: json['transactionId'] as String?,
      paymentUrl: json['paymentUrl'] as String?,
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt'] as String) : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert PaymentModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'orderId': orderId,
      'appointmentId': appointmentId,
      'amount': amount,
      'method': method,
      'status': status,
      'transactionId': transactionId,
      'paymentUrl': paymentUrl,
      'paidAt': paidAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/// Payment Preference Model
///
/// Represents a payment preference (e.g., Mercado Pago).
class PaymentPreferenceModel {
  final String id;
  final String preferenceId;
  final String initPoint;
  final String sandboxInitPoint;

  PaymentPreferenceModel({
    required this.id,
    required this.preferenceId,
    required this.initPoint,
    required this.sandboxInitPoint,
  });

  /// Create PaymentPreferenceModel from JSON
  factory PaymentPreferenceModel.fromJson(Map<String, dynamic> json) {
    return PaymentPreferenceModel(
      id: json['id'] as String,
      preferenceId: json['preferenceId'] as String,
      initPoint: json['initPoint'] as String,
      sandboxInitPoint: json['sandboxInitPoint'] as String,
    );
  }

  /// Convert PaymentPreferenceModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'preferenceId': preferenceId,
      'initPoint': initPoint,
      'sandboxInitPoint': sandboxInitPoint,
    };
  }
}
