import '../models/order_model.dart';
import 'api_service.dart';
import '../config/api_config.dart';

class OrderService {
  final ApiService _apiService;
  
  OrderService(this._apiService);
  
  Future<OrderModel> createOrder(Map<String, dynamic> data) async {
    final response = await _apiService.post(ApiConfig.orders, data: data);
    return OrderModel.fromJson(response.data['order']);
  }
  
  Future<List<OrderModel>> getOrders() async {
    final response = await _apiService.get(ApiConfig.orders);
    return (response.data['orders'] as List)
        .map((e) => OrderModel.fromJson(e))
        .toList();
  }
  
  Future<OrderModel> getOrderById(String id) async {
    final response = await _apiService.get('${ApiConfig.orders}/$id');
    return OrderModel.fromJson(response.data['order']);
  }
  
  Future<OrderStatsModel> getOrderStats() async {
    final response = await _apiService.get('${ApiConfig.orders}/stats');
    return OrderStatsModel.fromJson(response.data);
  }
  
  Future<void> cancelOrder(String id) async {
    await _apiService.patch('${ApiConfig.orders}/$id/cancel');
  }
}
