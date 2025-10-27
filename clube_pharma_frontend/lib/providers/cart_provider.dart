import 'package:flutter/foundation.dart';
import '../models/cart_model.dart';
import '../services/api_service.dart';
import '../services/cart_service.dart';

/// Cart Provider
class CartProvider with ChangeNotifier {
  final CartService _cartService;

  CartSummaryModel? _cart;
  bool _isLoading = false;
  String? _error;

  CartProvider({CartService? cartService})
      : _cartService = cartService ?? CartService(ApiService());

  CartSummaryModel? get cart => _cart;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get itemCount => _cart?.itemCount ?? 0;
  double get total => _cart?.total ?? 0.0;

  Future<void> getCart() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _cart = await _cartService.getCart();
      _error = null;
    } on ApiException catch (e) {
      _error = e.userMessage;
    } catch (e) {
      _error = 'Failed to load cart.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToCart(String productId, int quantity) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _cartService.addToCart(productId, quantity);
      await getCart(); // Refresh cart
      _error = null;
      return true;
    } on ApiException catch (e) {
      _error = e.userMessage;
      return false;
    } catch (e) {
      _error = 'Failed to add to cart.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateCartItem(String itemId, int quantity) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _cartService.updateCartItem(itemId, quantity);
      await getCart(); // Refresh cart
      _error = null;
      return true;
    } on ApiException catch (e) {
      _error = e.userMessage;
      return false;
    } catch (e) {
      _error = 'Failed to update cart.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> removeFromCart(String itemId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _cartService.removeFromCart(itemId);
      await getCart(); // Refresh cart
      _error = null;
      return true;
    } on ApiException catch (e) {
      _error = e.userMessage;
      return false;
    } catch (e) {
      _error = 'Failed to remove from cart.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> clearCart() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _cartService.clearCart();
      _cart = null;
      _error = null;
      return true;
    } on ApiException catch (e) {
      _error = e.userMessage;
      return false;
    } catch (e) {
      _error = 'Failed to clear cart.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clear() {
    _cart = null;
    _error = null;
    notifyListeners();
  }
}
