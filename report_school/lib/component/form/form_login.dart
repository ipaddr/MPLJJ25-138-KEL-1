import 'package:flutter/material.dart';
import 'package:report_school/pages/register_page.dart';
import 'package:report_school/pages/nav_app.dart';

class FormLogin extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Email Field
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Email',
                style: TextStyle(color: textColor),
              ),
            ),
            const SizedBox(height: 4),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'example@gmail.com',
                // ignore: deprecated_member_use
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                hintFadeDuration: const Duration(milliseconds: 500),
                filled: true,
                fillColor: fieldColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              style: TextStyle(color: Colors.black),
            ),

            const SizedBox(height: 12),

            // Password Field
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Password',
                style: TextStyle(color: textColor),
              ),
            ),
            // Password Field
           TextFormField(
              obscureText: true, // agar jadi ****
              decoration: InputDecoration(
                hintText: '••••••••••',
                // ignore: deprecated_member_use
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                hintFadeDuration: const Duration(milliseconds: 500),
                filled: true,
                fillColor: fieldColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 16),
           
            // Sign In Button
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Aksi ketika tombol ditekan
                  // Misalnya, navigasi ke halaman utama
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder: (context, animation, secondaryAnimation) => const NavApp(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF9149), 
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Sign In'),
              ),
            ),

            const SizedBox(height: 8),

            // Bottom Text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Belum punya akun? ',
                  style: TextStyle(color: bottomTextColor),
                ),
                GestureDetector(
                  onTap: () {
                    // Aksi ketika teks ditekan
                    // Misalnya, navigasi ke halaman pendaftaran
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 300),
                        pageBuilder: (context, animation, secondaryAnimation) => const RegisterPage(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                           return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Text(
                    'Daftar disini',
                    style: TextStyle(
                      color: bottomTextColor2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
