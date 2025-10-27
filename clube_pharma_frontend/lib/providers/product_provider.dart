import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../services/product_service.dart';

/// Product Provider
class ProductProvider with ChangeNotifier {
  final ProductService _productService;

  List<ProductModel> _products = [];
  List<CategoryModel> _categories = [];
  ProductModel? _selectedProduct;
  bool _isLoading = false;
  String? _error;

  ProductProvider({ProductService? productService})
      : _productService = productService ?? ProductService(ApiService());

  List<ProductModel> get products => _products;
  List<CategoryModel> get categories => _categories;
  ProductModel? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getProducts({String? category, String? search}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _products = await _productService.getProducts(
        category: category,
        search: search,
      );
      _error = null;
    } on ApiException catch (e) {
      _error = e.userMessage;
    } catch (e) {
      _error = 'Failed to load products.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCategories() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _categories = await _productService.getCategories();
      _error = null;
    } on ApiException catch (e) {
      _error = e.userMessage;
    } catch (e) {
      _error = 'Failed to load categories.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProductById(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _selectedProduct = await _productService.getProductById(id);
      _error = null;
    } on ApiException catch (e) {
      _error = e.userMessage;
    } catch (e) {
      _error = 'Failed to load product.';
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
    _products = [];
    _categories = [];
    _selectedProduct = null;
    _error = null;
    notifyListeners();
  }
}
