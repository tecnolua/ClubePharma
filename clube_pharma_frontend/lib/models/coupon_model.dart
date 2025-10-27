/// Coupon Model
///
/// Represents a discount coupon in the ClubePharma system.
class CouponModel {
  final String id;
  final String code;
  final String type; // PERCENTAGE or FIXED
  final double value;
  final double? minPurchaseAmount;
  final DateTime? expiresAt;
  final int? usageLimit;
  final int usageCount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  CouponModel({
    required this.id,
    required this.code,
    required this.type,
    required this.value,
    this.minPurchaseAmount,
    this.expiresAt,
    this.usageLimit,
    required this.usageCount,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create CouponModel from JSON
  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'] as String,
      code: json['code'] as String,
      type: json['type'] as String,
      value: (json['value'] as num).toDouble(),
      minPurchaseAmount: json['minPurchaseAmount'] != null ? (json['minPurchaseAmount'] as num).toDouble() : null,
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt'] as String) : null,
      usageLimit: json['usageLimit'] as int?,
      usageCount: json['usageCount'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert CouponModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'type': type,
      'value': value,
      'minPurchaseAmount': minPurchaseAmount,
      'expiresAt': expiresAt?.toIso8601String(),
      'usageLimit': usageLimit,
      'usageCount': usageCount,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Check if coupon is valid
  bool get isValid {
    if (!isActive) return false;
    if (expiresAt != null && expiresAt!.isBefore(DateTime.now())) return false;
    if (usageLimit != null && usageCount >= usageLimit!) return false;
    return true;
  }

  /// Calculate discount amount for given total
  double calculateDiscount(double total) {
    if (!isValid) return 0;
    if (minPurchaseAmount != null && total < minPurchaseAmount!) return 0;
    
    if (type == 'PERCENTAGE') {
      return (total * value) / 100;
    } else {
      return value;
    }
  }
}
