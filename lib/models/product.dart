import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final String? imageAsset;
  final String category;
  final String manufacturer;
  final String certification;
  final String certificationNumber;
  final DateTime certificationExpiry;
  final List<String> ingredients;
  final double rating;
  final int reviewCount;
  final double price;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
  this.imageUrl,
  this.imageAsset,
    required this.category,
    required this.manufacturer,
    required this.certification,
    required this.certificationNumber,
    required this.certificationExpiry,
    required this.ingredients,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.price,
    this.isFavorite = false,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? imageAsset,
    String? category,
    String? manufacturer,
    String? certification,
    String? certificationNumber,
    DateTime? certificationExpiry,
    List<String>? ingredients,
    double? rating,
    int? reviewCount,
    double? price,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    imageUrl: imageUrl ?? this.imageUrl,
    imageAsset: imageAsset ?? this.imageAsset,
      category: category ?? this.category,
      manufacturer: manufacturer ?? this.manufacturer,
      certification: certification ?? this.certification,
      certificationNumber: certificationNumber ?? this.certificationNumber,
      certificationExpiry: certificationExpiry ?? this.certificationExpiry,
      ingredients: ingredients ?? this.ingredients,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      price: price ?? this.price,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  // Create Product from Firestore document
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      imageAsset: data['imageAsset'],
      category: data['category'] ?? '',
      manufacturer: data['manufacturer'] ?? '',
      certification: data['certification'] ?? '',
      certificationNumber: data['certificationNumber'] ?? '',
      certificationExpiry: (data['certificationExpiry'] as Timestamp).toDate(),
      ingredients: List<String>.from(data['ingredients'] ?? []),
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      price: (data['price'] ?? 0.0).toDouble(),
      isFavorite: data['isFavorite'] ?? false,
    );
  }

  // Convert Product to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'imageAsset': imageAsset,
      'category': category,
      'manufacturer': manufacturer,
      'certification': certification,
      'certificationNumber': certificationNumber,
      'certificationExpiry': Timestamp.fromDate(certificationExpiry),
      'ingredients': ingredients,
      'rating': rating,
      'reviewCount': reviewCount,
      'price': price,
      'isFavorite': isFavorite,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // For local storage (SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'imageAsset': imageAsset,
      'category': category,
      'manufacturer': manufacturer,
      'certification': certification,
      'certificationNumber': certificationNumber,
      'certificationExpiry': certificationExpiry.toIso8601String(),
      'ingredients': ingredients,
      'rating': rating,
      'reviewCount': reviewCount,
      'price': price,
      'isFavorite': isFavorite,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      imageAsset: json['imageAsset'],
      category: json['category'],
      manufacturer: json['manufacturer'],
      certification: json['certification'],
      certificationNumber: json['certificationNumber'],
      certificationExpiry: DateTime.parse(json['certificationExpiry']),
      ingredients: List<String>.from(json['ingredients']),
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      price: json['price']?.toDouble() ?? 0.0,
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
