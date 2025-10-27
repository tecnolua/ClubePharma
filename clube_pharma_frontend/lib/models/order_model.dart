/// Order Model
///
/// Represents an order in the ClubePharma system.
class OrderModel {
  final String id;
  final String userId;
  final String orderNumber;
  final String status; // PENDING, PROCESSING, SHIPPED, DELIVERED, CANCELLED
  final double subtotal;
  final double discount;
  final double shipping;
  final double total;
  final String? couponCode;
  final String paymentMethod;
  final String paymentStatus; // PENDING, PAID, FAILED, REFUNDED
  final String? trackingCode;
  final List<OrderItemModel>? items;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.orderNumber,
    required this.status,
    required this.subtotal,
    required this.discount,
    required this.shipping,
    required this.total,
    this.couponCode,
    required this.paymentMethod,
    required this.paymentStatus,
    this.trackingCode,
    this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create OrderModel from JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      orderNumber: json['orderNumber'] as String,
      status: json['status'] as String,
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      shipping: (json['shipping'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      couponCode: json['couponCode'] as String?,
      paymentMethod: json['paymentMethod'] as String,
      paymentStatus: json['paymentStatus'] as String,
      trackingCode: json['trackingCode'] as String?,
      items: json['items'] != null ? (json['items'] as List).map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>)).toList() : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert OrderModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'orderNumber': orderNumber,
      'status': status,
      'subtotal': subtotal,
      'discount': discount,
      'shipping': shipping,
      'total': total,
      'couponCode': couponCode,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'trackingCode': trackingCode,
      'items': items?.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Check if order can be cancelled
  bool get canBeCancelled => status == 'PENDING' || status == 'PROCESSING';
}

/// Order Item Model
///
/// Represents an item within an order.
class OrderItemModel {
  final String id;
  final String orderId;
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final double subtotal;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  /// Create OrderItemModel from JSON
  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }

  /// Convert OrderItemModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }
}

/// Order Stats Model
///
/// Represents order statistics.
class OrderStatsModel {
  final int totalOrders;
  final int pendingOrders;
  final int deliveredOrders;
  final double totalRevenue;

  OrderStatsModel({
    required this.totalOrders,
    required this.pendingOrders,
    required this.deliveredOrders,
    required this.totalRevenue,
  });

  /// Create OrderStatsModel from JSON
  factory OrderStatsModel.fromJson(Map<String, dynamic> json) {
    return OrderStatsModel(
      totalOrders: json['totalOrders'] as int? ?? 0,
      pendingOrders: json['pendingOrders'] as int? ?? 0,
      deliveredOrders: json['deliveredOrders'] as int? ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0,
    );
  }

  /// Convert OrderStatsModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalOrders': totalOrders,
      'pendingOrders': pendingOrders,
      'deliveredOrders': deliveredOrders,
      'totalRevenue': totalRevenue,
    };
  }
}
