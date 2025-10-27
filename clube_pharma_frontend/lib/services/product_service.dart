import '../models/product_model.dart';
import 'api_service.dart';
import '../config/api_config.dart';

class ProductService {
  final ApiService _apiService;
  
  ProductService(this._apiService);
  
  Future<List<ProductModel>> getProducts({String? category, String? search}) async {
    final response = await _apiService.get(
      ApiConfig.products,
      queryParameters: {
        if (category != null) 'category': category,
        if (search != null) 'search': search,
      },
    );
    return (response.data['products'] as List)
        .map((e) => ProductModel.fromJson(e))
        .toList();
  }
  
  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiService.get('${ApiConfig.products}/categories');
    return (response.data['categories'] as List)
        .map((e) => CategoryModel.fromJson(e))
        .toList();
  }
  
  Future<ProductModel> getProductById(String id) async {
    final response = await _apiService.get('${ApiConfig.products}/$id');
    return ProductModel.fromJson(response.data['product']);
  }
}
