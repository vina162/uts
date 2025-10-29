import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user.dart';
import '../services/storage_service.dart';
import '../services/auth_service.dart';

class UserProvider with ChangeNotifier {
  final StorageService _storage;
  final AuthService _auth = AuthService();
  User? _user;

  UserProvider(this._storage) {
    _loadUser();
    _setupAuthListener();
  }

  User? get user => _user;

  void _setupAuthListener() {
    _auth.authStateChanges.listen((firebase_auth.User? firebaseUser) async {
      if (firebaseUser == null) {
        await clearUser();
      } else {
        final role = await _auth.getUserRole(firebaseUser.uid);
        final user = User(
          id: firebaseUser.uid,
          username: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          fullName: firebaseUser.displayName ?? '',
          profileImage: firebaseUser.photoURL,
          role: role,
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
        );
        await setUser(user);
      }
    });
  }

  Future<void> _loadUser() async {
    _user = _storage.getUser();
    notifyListeners();
  }

  Future<void> setUser(User user) async {
    _user = user;
    await _storage.saveUser(user);
    notifyListeners();
  }

  Future<void> clearUser() async {
    _user = null;
    await _storage.saveUser(User(
      id: '',
      username: '',
      email: '',
      fullName: '',
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
      favoriteProductIds: [],
    ));
    notifyListeners();
  }

  Future<void> updateUserName(String newName) async {
    if (_user != null) {
      await _auth.updateProfile(
        uid: _user!.id,
        name: newName,
      );
      _user = _user!.copyWith(fullName: newName, username: newName);
      await _storage.saveUser(_user!);
      notifyListeners();
    }
  }
}
