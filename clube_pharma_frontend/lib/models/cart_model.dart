/// Cart Item Model
///
/// Represents an item in the shopping cart.
class CartItemModel {
  final String id;
  final String userId;
  final String productId;
  final int quantity;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProductCartInfo? product;

  CartItemModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
    this.product,
  });

  /// Create CartItemModel from JSON
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      productId: json['productId'] as String,
      quantity: json['quantity'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      product: json['product'] != null ? ProductCartInfo.fromJson(json['product'] as Map<String, dynamic>) : null,
    );
  }

  /// Convert CartItemModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'quantity': quantity,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'product': product?.toJson(),
    };
  }

  /// Get subtotal for this item
  double get subtotal => (product?.price ?? 0) * quantity;
}

/// Product Cart Info
///
/// Simplified product info for cart items.
class ProductCartInfo {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;
  final bool requiresPrescription;

  ProductCartInfo({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    required this.requiresPrescription,
  });

  factory ProductCartInfo.fromJson(Map<String, dynamic> json) {
    return ProductCartInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      requiresPrescription: json['requiresPrescription'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'requiresPrescription': requiresPrescription,
    };
  }
}

/// Cart Summary Model
///
/// Represents the complete cart with items and totals.
class CartSummaryModel {
  final List<CartItemModel> items;
  final double subtotal;
  final double discount;
  final double shipping;
  final double total;

  CartSummaryModel({
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.shipping,
    required this.total,
  });

  /// Create CartSummaryModel from JSON
  factory CartSummaryModel.fromJson(Map<String, dynamic> json) {
    return CartSummaryModel(
      items: (json['items'] as List?)?.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      shipping: (json['shipping'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
    );
  }

  /// Convert CartSummaryModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'discount': discount,
      'shipping': shipping,
      'total': total,
    };
  }

  /// Get total number of items
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}
