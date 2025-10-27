import '../models/cart_model.dart';
import 'api_service.dart';
import '../config/api_config.dart';

class CartService {
  final ApiService _apiService;
  
  CartService(this._apiService);
  
  Future<CartSummaryModel> getCart() async {
    final response = await _apiService.get(ApiConfig.cart);
    return CartSummaryModel.fromJson(response.data);
  }
  
  Future<void> addToCart(String productId, int quantity) async {
    await _apiService.post(
      ApiConfig.cart,
      data: {
        'productId': productId,
        'quantity': quantity,
      },
    );
  }
  
  Future<void> updateCartItem(String id, int quantity) async {
    await _apiService.put(
      '${ApiConfig.cart}/$id',
      data: {'quantity': quantity},
    );
  }
  
  Future<void> removeFromCart(String id) async {
    await _apiService.delete('${ApiConfig.cart}/$id');
  }
  
  Future<void> clearCart() async {
    await _apiService.delete('${ApiConfig.cart}/clear');
  }
}
