import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/product_provider.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/admin/admin_dashboard_page.dart';
import 'services/storage_service.dart';
import 'services/auth_service.dart';
import 'services/product_service.dart';
import 'services/firebase_storage_service.dart';
import 'providers/favorites_provider.dart';
import 'providers/user_provider.dart';

Future<void> initializeFirebase() async {
  try {
    // Try initialize with generated options first (flutterfire)
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized with DefaultFirebaseOptions');
  } catch (e) {
    debugPrint('DefaultFirebaseOptions unavailable or failed: $e');
    try {
      // Fallback: try to initialize without explicit options
      await Firebase.initializeApp();
      debugPrint('Firebase initialized without explicit options');
    } catch (e2) {
      // If both fail, log and continue — app can still run in a degraded mode
      debugPrint('Firebase initialization failed: $e2');
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  
  final prefs = await SharedPreferences.getInstance();
  final storageService = StorageService(prefs);
  final authService = AuthService();
  final productService = ProductService();
  
  runApp(
    MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService),
        Provider<AuthService>.value(value: authService),
        Provider<ProductService>.value(value: productService),
        Provider<FirebaseStorageService>(
          create: (_) => FirebaseStorageService(),
        ),
            ChangeNotifierProvider(
              create: (_) => ProductProvider(productService),
            ),
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider(storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(storageService),
        ),
      ],
      child: const HalalFinderApp(),
    ),
  );
}

class HalalFinderApp extends StatelessWidget {
  const HalalFinderApp({super.key});

  static const Color darkGreen = Color(0xFF1B5E20);
  static const Color darkBg = Color(0xFF121212);

  @override
  Widget build(BuildContext context) {
    final base = ThemeData.dark();
  final userProvider = Provider.of<UserProvider>(context);

  return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HalalFinder',
      theme: base.copyWith(
        scaffoldBackgroundColor: darkBg,
        primaryColor: darkGreen,
        colorScheme: base.colorScheme.copyWith(
          primary: darkGreen,
          surface: darkBg,
          onSurface: Colors.white,
          onPrimary: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: darkBg,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.6)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
        textTheme: base.textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: darkGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
        ),
      ),
      home: userProvider.user != null 
          ? (userProvider.user!.role == 'admin' 
              ? const AdminDashboardPage() 
              : const HomePage())
          : const LoginPage(),
    );
  }
}
