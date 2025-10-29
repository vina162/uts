import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a user's profile image and returns the public download URL.
  Future<String> uploadUserProfileImage(File file, String uid) async {
    final ref = _storage.ref().child('users/$uid/profile.jpg');
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }

  /// Uploads a product image and returns the public download URL.
  Future<String> uploadProductImage(File file, String productId) async {
    final ref = _storage.ref().child('products/$productId/image.jpg');
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }
}
