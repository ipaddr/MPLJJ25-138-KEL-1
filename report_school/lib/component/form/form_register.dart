import 'package:flutter/material.dart';
import 'package:report_school/pages/login_page.dart';

class FormRegister extends StatefulWidget {
  final Color backgroundColor;
  final Color textColor;
  final Color fieldColor;
  final Color bottomTextColor;
  final Color? bottomTextColor2;

  const FormRegister({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    required this.fieldColor,
    required this.bottomTextColor,
    this.bottomTextColor2,
  });

  @override
  State<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  bool _obscurePassword = true; // State untuk toggle

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.backgroundColor,
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
                style: TextStyle(color: widget.textColor),
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
                fillColor: widget.fieldColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              style: const TextStyle(color: Colors.black),
            ),

            const SizedBox(height: 12),

            // Password Label
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Password',
                style: TextStyle(color: widget.textColor),
              ),
            ),

            // Password Field dengan toggle visibility
            TextFormField(
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: '••••••••••',
                // ignore: deprecated_member_use
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                filled: true,
                fillColor: widget.fieldColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              style: const TextStyle(color: Colors.black),
            ),

            const SizedBox(height: 12),
            
            // Password Label
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Konfirmasi Password',
                style: TextStyle(color: widget.textColor),
              ),
            ),

             // Password Field dengan toggle visibility
            TextFormField(
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: '••••••••••',
                // ignore: deprecated_member_use
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                filled: true,
                fillColor: widget.fieldColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              style: const TextStyle(color: Colors.black),
            ),

            const SizedBox(height: 16),

            // Sign In Button
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9149),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Register'),
              ),
            ),

            const SizedBox(height: 8),

            // Bottom Text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sudah punya akun? ',
                  style: TextStyle(color: widget.bottomTextColor),
                ),
                GestureDetector(
                  onTap: () {
                    // Aksi ketika tombol ditekan
                    Navigator.pushReplacement(
                      context, 
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 300),
                        pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
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
                    'Login di sini',
                    style: TextStyle(
                      color: widget.bottomTextColor2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
