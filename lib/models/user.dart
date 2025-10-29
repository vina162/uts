import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final String? profileImage;
  final List<String> favoriteProductIds;
  final DateTime createdAt;
  final DateTime lastLogin;
  final String role;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    this.profileImage,
    List<String>? favoriteProductIds,
    DateTime? createdAt,
    DateTime? lastLogin,
    String? role,
  }) : 
    favoriteProductIds = favoriteProductIds ?? [],
    createdAt = createdAt ?? DateTime.now(),
    lastLogin = lastLogin ?? DateTime.now(),
    role = role ?? 'user';

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? fullName,
    String? profileImage,
    List<String>? favoriteProductIds,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      profileImage: profileImage ?? this.profileImage,
      favoriteProductIds: favoriteProductIds ?? this.favoriteProductIds,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'fullName': fullName,
      'profileImage': profileImage,
      'favoriteProductIds': favoriteProductIds,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
      'role': role,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      fullName: json['fullName'],
      profileImage: json['profileImage'],
      favoriteProductIds: List<String>.from(json['favoriteProductIds'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      lastLogin: DateTime.parse(json['lastLogin']),
      role: json['role'] ?? 'user',
    );
  }

  // Firestore serialization
  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      profileImage: data['profileImage'],
      favoriteProductIds: List<String>.from(data['favoriteProductIds'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastLogin: (data['lastLogin'] as Timestamp).toDate(),
      role: data['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'email': email,
      'fullName': fullName,
      'profileImage': profileImage,
      'favoriteProductIds': favoriteProductIds,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLogin': Timestamp.fromDate(lastLogin),
      'role': role,
    };
  }

  bool get isAdmin => role == 'admin';
}