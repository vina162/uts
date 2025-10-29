import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';

  // Get all products stream
  Stream<List<Product>> getProducts() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromFirestore(doc))
            .toList());
  }

  // Get products by category
  Stream<List<Product>> getProductsByCategory(String category) {
    return _firestore
        .collection(_collection)
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromFirestore(doc))
            .toList());
  }

  // Search products by name or category
  Stream<List<Product>> searchProducts(String query) {
    return _firestore
        .collection(_collection)
        .orderBy('name')
        .startAt([query])
        .endAt(['$query\uf8ff'])
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromFirestore(doc))
            .toList());
  }

  // Add new product (admin only)
  Future<void> addProduct(Product product) async {
    try {
      await _firestore.collection(_collection).add(product.toFirestore());
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  // Update product (admin only)
  Future<void> updateProduct(String id, Product product) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(id)
          .update(product.toFirestore());
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  // Delete product (admin only)
  Future<void> deleteProduct(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  // Get single product
  Future<Product?> getProduct(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return Product.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }
}