import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../pages/register_page.dart';
import '../../pages/nav_app.dart';
import '../../config/api.dart'; // <-- pastikan file api.dart sudah ada
import 'package:flutter/foundation.dart' show kDebugMode;

class FormLogin extends StatefulWidget {
  final Color backgroundColor;
  final Color textColor;
  final Color fieldColor;
  final Color bottomTextColor;
  final Color? bottomTextColor2;

  const FormLogin({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    required this.fieldColor,
    required this.bottomTextColor,
    this.bottomTextColor2,
  });

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  Future<void> login() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    // Validasi input
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        isLoading = false;
        errorMessage = 'Email dan password tidak boleh kosong.';
      });
      return;
    }

    // Kirim permintaan login ke API
    if (!mounted) return; // Cek apakah widget masih ada di tree

    // Apakah email valid?
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(emailController.text.trim())) {
      setState(() {
        isLoading = false;
        errorMessage = 'Email tidak valid.';
      });
      return;
    }

    // Apakah 8 karakter password?
    if (passwordController.text.trim().length < 8) {
      setState(() {
        isLoading = false;
        errorMessage = 'Password harus minimal 8 karakter.';
      });
      return;
    }

    final response = await http.post(
      Uri.parse(apiLogin),
      headers: {'Accept': 'application/json'},
      body: {
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      },
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      
      if (!mounted) return; // Cek apakah widget masih ada di tree

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NavApp()),
      );
    } else {
      final data = json.decode(response.body);
      // Print error message ke konsol untuk debugging
      if (kDebugMode) {
        print('Login failed: ${data['message']}');
      } else {
        // Jika tidak dalam mode debug, tampilkan pesan kesalahan di UI
        debugPrint('Login failed: ${data['message']}');
      }
      setState(() {
        errorMessage = data['message'] ?? 'Login gagal.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            Align(
              alignment: Alignment.centerLeft,
              child: Text('Email', style: TextStyle(color: widget.textColor)),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'example@gmail.com',
                filled: true,
                fillColor: widget.fieldColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerLeft,
              child: Text('Password', style: TextStyle(color: widget.textColor)),
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '••••••••',
                filled: true,
                fillColor: widget.fieldColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9149),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Sign In'),
              ),
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Belum punya akun? ', style: TextStyle(color: widget.bottomTextColor)),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },
                  child: Text(
                    'Daftar disini',
                    style: TextStyle(
                      color: widget.bottomTextColor2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
