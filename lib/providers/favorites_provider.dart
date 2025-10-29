import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';
import '../models/product.dart';

class FavoritesProvider with ChangeNotifier {
  final StorageService _storage;
  List<String> _favoriteIds = [];
  List<Product> _products = [];

  FavoritesProvider(this._storage) {
    _loadFavorites();
    _loadProducts();
  }

  List<Product> get favorites {
    return _products.where((product) => _favoriteIds.contains(product.id)).toList();
  }

  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }

  Future<void> toggleFavorite(String productId) async {
    await _storage.toggleFavorite(productId);
    _favoriteIds = _storage.getFavoriteIds();
    
    // Update the isFavorite status in the product list
    final productIndex = _products.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      _products[productIndex] = _products[productIndex].copyWith(
        isFavorite: _favoriteIds.contains(productId),
      );
    }
    
    notifyListeners();
  }

  Future<void> _loadFavorites() async {
    _favoriteIds = _storage.getFavoriteIds();
    notifyListeners();
  }

  Future<void> _loadProducts() async {
    _products = _storage.getProducts();
    // Update products' favorite status based on favoriteIds
    _products = _products.map((product) {
      return product.copyWith(
        isFavorite: _favoriteIds.contains(product.id),
      );
    }).toList();
    notifyListeners();
  }

  Future<void> updateProducts(List<Product> products) async {
    await _storage.saveProducts(products);
    await _loadProducts();
  }
}