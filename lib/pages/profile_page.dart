import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/firebase_storage_service.dart';
import '../services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isUploading = false;
  bool _isEditingName = false;
  final _nameController = TextEditingController();

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;

    final file = File(picked.path);
    // Capture objects before awaiting to avoid using BuildContext across async gaps
    // ignore: use_build_context_synchronously
    final storageService = Provider.of<FirebaseStorageService>(context, listen: false);
    // ignore: use_build_context_synchronously
    final authService = Provider.of<AuthService>(context, listen: false);
    // ignore: use_build_context_synchronously
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.user;
    if (currentUser == null) return;

    // ignore: use_build_context_synchronously
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _isUploading = true);
    try {
      final url = await storageService.uploadUserProfileImage(file, currentUser.id);
      // Update Firestore user document
      await authService.updateProfile(uid: currentUser.id, photoUrl: url);

      // Update local provider user
      final updated = currentUser.copyWith(profileImage: url);
      await userProvider.setUser(updated);

      // Use captured messenger (safe) and avoid using context after await
      messenger.showSnackBar(const SnackBar(content: Text('Profile image updated')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Consumer<UserProvider>(
                builder: (context, userProvider, _) {
                  final user = userProvider.user;
                  final imageUrl = user?.profileImage;
                  return GestureDetector(
                    onTap: _isUploading ? null : () => _pickAndUploadImage(context),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.6),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 52,
                        backgroundColor: Colors.white12,
                        backgroundImage: imageUrl != null ? NetworkImage(imageUrl) as ImageProvider : null,
                        child: imageUrl == null ? const Icon(Icons.person, size: 52, color: Colors.white) : null,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Consumer<UserProvider>(
                builder: (context, userProvider, _) {
                  final user = userProvider.user;
                  return Column(
                    children: [
                      if (_isEditingName)
                        TextField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Enter new name',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () async {
                                final newName = _nameController.text.trim();
                                if (newName.isNotEmpty) {
                                  await userProvider.updateUserName(newName);
                                  if (mounted) {
                                    setState(() => _isEditingName = false);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Name updated successfully'))
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isEditingName = true;
                              _nameController.text = user?.fullName ?? '';
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user?.fullName ?? 'Nama Pengguna',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.edit, color: Colors.white70, size: 20),
                            ],
                          ),
                        ),
                      const SizedBox(height: 6),
                      Text(user?.email ?? 'user@example.com',
                          style: const TextStyle(color: Colors.white70)),
                    ],
                  );
                },
              ),
              const SizedBox(height: 18),

              // Stats card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFF141414), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    _StatItem(label: 'Favorit', value: '12'),
                    _StatItem(label: 'Dilihat', value: '128'),
                    _StatItem(label: 'Sertifikat', value: '3'),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Sign out using AuthService and clear user provider
                    final authService = Provider.of<AuthService>(context, listen: false);
                    final userProvider = Provider.of<UserProvider>(context, listen: false);
                    await authService.signOut();
                    await userProvider.clearUser();
                    if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Logout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
