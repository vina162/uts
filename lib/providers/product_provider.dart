import 'package:flutter/foundation.dart';
import '../services/product_service.dart';
import '../models/product.dart';
import '../data/sample_data.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService;
  List<Product> _products = [];
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  bool _isLoading = false;
  String? _error;

  ProductProvider(this._productService) {
    _initializeProducts();
  }

  List<Product> get products => _getFilteredProducts();
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<Product> _getFilteredProducts() {
    return _products.where((product) {
      final matchesQuery = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.category.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory =
          _selectedCategory == 'Semua' || product.category == _selectedCategory;

      return matchesQuery && matchesCategory;
    }).toList();
  }

  Future<void> _initializeProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _productService.getProducts().listen(
        (products) {
          // If Firestore returns no products (e.g. not configured or empty),
          // fall back to local sample data so UI shows product assets during development.
          if (products.isEmpty) {
            _products = sampleProducts;
          } else {
            _products = products;
          }
          _isLoading = false;
          notifyListeners();
        },
        onError: (error) {
          _error = error.toString();
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void refreshProducts() {
    _initializeProducts();
  }

  Future<Product?> getProductById(String id) async {
    try {
      return await _productService.getProduct(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
}