import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Register with email and password
  Future<UserCredential> register(String email, String password, String name) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'name': name,
        'email': email,
        'role': 'user', // Default role is user
        'createdAt': FieldValue.serverTimestamp(),
      });

      return credential;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get user role
  Future<String> getUserRole(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data()?['role'] ?? 'user';
    } catch (e) {
      throw Exception('Failed to get user role: $e');
    }
  }

  // Update user profile
  Future<void> updateProfile({
    required String uid,
    String? name,
    String? photoUrl,
  }) async {
    try {
      final updates = <String, dynamic>{
        if (name != null) 'name': name,
        if (photoUrl != null) 'photoUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('users').doc(uid).update(updates);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}