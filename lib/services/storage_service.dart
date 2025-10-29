import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/user.dart';

class StorageService {
  static const String _userKey = 'user_data';
  static const String _favoritesKey = 'favorite_products';
  static const String _productsKey = 'all_products';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // User related methods
  Future<void> saveUser(User user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  User? getUser() {
    final userStr = _prefs.getString(_userKey);
    if (userStr == null) return null;
    return User.fromJson(jsonDecode(userStr));
  }

  // Products related methods
  Future<void> saveProducts(List<Product> products) async {
    final productsJson = products.map((p) => p.toJson()).toList();
    await _prefs.setString(_productsKey, jsonEncode(productsJson));
  }

  List<Product> getProducts() {
    final productsStr = _prefs.getString(_productsKey);
    if (productsStr == null) return [];
    final productsJson = jsonDecode(productsStr) as List;
    return productsJson.map((p) => Product.fromJson(p)).toList();
  }

  // Favorites related methods
  Future<void> saveFavorites(List<String> favoriteIds) async {
    await _prefs.setStringList(_favoritesKey, favoriteIds);
  }

  List<String> getFavoriteIds() {
    return _prefs.getStringList(_favoritesKey) ?? [];
  }

  Future<void> toggleFavorite(String productId) async {
    final favorites = getFavoriteIds();
    if (favorites.contains(productId)) {
      favorites.remove(productId);
    } else {
      favorites.add(productId);
    }
    await saveFavorites(favorites);
  }

  bool isFavorite(String productId) {
    return getFavoriteIds().contains(productId);
  }
}