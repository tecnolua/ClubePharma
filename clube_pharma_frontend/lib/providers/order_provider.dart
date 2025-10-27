import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../services/api_service.dart';
import '../services/order_service.dart';

/// Order Provider
class OrderProvider with ChangeNotifier {
  final OrderService _orderService;

  List<OrderModel> _orders = [];
  OrderModel? _selectedOrder;
  bool _isLoading = false;
  String? _error;

  OrderProvider({OrderService? orderService})
      : _orderService = orderService ?? OrderService(ApiService());

  List<OrderModel> get orders => _orders;
  OrderModel? get selectedOrder => _selectedOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getOrders() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _orders = await _orderService.getOrders();
      _error = null;
    } on ApiException catch (e) {
      _error = e.userMessage;
    } catch (e) {
      _error = 'Failed to load orders.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getOrderById(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _selectedOrder = await _orderService.getOrderById(id);
      _error = null;
    } on ApiException catch (e) {
      _error = e.userMessage;
    } catch (e) {
      _error = 'Failed to load order.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createOrder(Map<String, dynamic> orderData) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final order = await _orderService.createOrder(orderData);
      _orders.insert(0, order);
      _error = null;
      return true;
    } on ApiException catch (e) {
      _error = e.userMessage;
      return false;
    } catch (e) {
      _error = 'Failed to create order.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> cancelOrder(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _orderService.cancelOrder(id);

      // Remove from list or refresh
      await getOrders();

      _error = null;
      return true;
    } on ApiException catch (e) {
      _error = e.userMessage;
      return false;
    } catch (e) {
      _error = 'Failed to cancel order.';
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
    _orders = [];
    _selectedOrder = null;
    _error = null;
    notifyListeners();
  }
}
