import 'package:flutter/material.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                // Logo
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.6), blurRadius: 12, offset: const Offset(0, 6))],
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.transparent,
                    child: Icon(Icons.search, size: 48, color: Color(0xFF1B5E20)),
                  ),
                ),
                const SizedBox(height: 18),
                const Text('HalalFinder', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                const Text('Temukan produk halal dengan mudah', style: TextStyle(color: Colors.white70), textAlign: TextAlign.center),
                const SizedBox(height: 28),

                // Card containing fields
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.5), blurRadius: 10, offset: const Offset(0, 6))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email, color: Colors.white70),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscure,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                          suffixIcon: IconButton(
                            icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton(
                        onPressed: _onLogin,
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const RegisterPage()),
                          ),
                          child: const Text('Belum punya akun?', style: TextStyle(color: Colors.white70)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Small footer
                Text('Versi 1.0', style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
