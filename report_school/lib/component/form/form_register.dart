import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/config/api.dart';
import '/pages/login_page.dart';

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
  bool _obscurePassword = true;
  bool showVerificationUI = false;
  bool isLoading = false;
  int countdown = 0;
  Timer? timer;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final codeController = TextEditingController();

  String? errorMessage;

  void startCountdown() {
    setState(() => countdown = 60);
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (countdown <= 1) {
        t.cancel();
      }
      setState(() => countdown--);
    });
  }

  Future<void> register() async {
    final email = emailController.text.trim();
    final pass = passwordController.text;
    final confirm = confirmPasswordController.text;

    setState(() => errorMessage = null);

    if (email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      setState(() => errorMessage = 'Semua field wajib diisi.');
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)) {
      setState(() => errorMessage = 'Format email tidak valid.');
      return;
    }

    if (pass.length < 8) {
      setState(() => errorMessage = 'Password minimal 8 karakter.');
      return;
    }

    if (pass != confirm) {
      setState(() => errorMessage = 'Konfirmasi password tidak cocok.');
      return;
    }

    setState(() => isLoading = true);

    try {
      final res = await http.post(Uri.parse(apiRegister), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }, body: jsonEncode({
        'email': email,
        'password': pass,
      }));

      final data = jsonDecode(res.body);

      if (res.statusCode == 201) {
        await http.post(Uri.parse(apiSendVerificationCode), headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }, body: jsonEncode({ 'email': email }));
        startCountdown();
        setState(() => showVerificationUI = true);
      } else {
        setState(() => errorMessage = data['message'] ?? 'Registrasi gagal.');
      }
    } catch (_) {
      setState(() => errorMessage = 'Gagal koneksi ke server.');
    }

    setState(() => isLoading = false);
  }

  Future<void> resendCode() async {
    if (countdown > 0) return;
    final email = emailController.text.trim();
    if (email.isEmpty) return;

    try {
      await http.post(Uri.parse(apiResendVerificationCode),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({'email': email}));

      setState(() => errorMessage = 'Kode verifikasi telah dikirim ulang.');
      codeController.clear();
      startCountdown();
    } catch (_) {
      setState(() => errorMessage = 'Gagal mengirim ulang kode.');
    }
  }

  Future<void> verifyCode() async {
    final code = codeController.text.trim();
    final email = emailController.text.trim();

    if (code.isEmpty) return;

    try {
      final res = await http.post(Uri.parse(apiVerifyCode), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }, body: jsonEncode({
        'email': email,
        'code': code,
      }));

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        if (!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
      } else {
        setState(() => errorMessage = data['message'] ?? 'Kode salah atau kadaluarsa.');
      }
    } catch (_) {
      setState(() => errorMessage = 'Verifikasi gagal, periksa koneksi.');
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    codeController.dispose();
    super.dispose();
  }

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
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
              ),

            // EMAIL
            Align(alignment: Alignment.centerLeft, child: Text('Email', style: TextStyle(color: widget.textColor))),
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

            // PASSWORD
            Align(alignment: Alignment.centerLeft, child: Text('Password', style: TextStyle(color: widget.textColor))),
            TextFormField(
              controller: passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: '••••••••••',
                filled: true,
                fillColor: widget.fieldColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // KONFIRMASI PASSWORD
            Align(alignment: Alignment.centerLeft, child: Text('Konfirmasi Password', style: TextStyle(color: widget.textColor))),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: '••••••••••',
                filled: true,
                fillColor: widget.fieldColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // TOMBOL REGISTER
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9149),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Register'),
              ),
            ),

            if (showVerificationUI) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 8),

              Align(alignment: Alignment.centerLeft, child: Text('Kode Verifikasi', style: TextStyle(color: widget.textColor))),
              const SizedBox(height: 4),
              TextFormField(
                controller: codeController,
                decoration: InputDecoration(
                  hintText: 'Masukkan kode dari email',
                  filled: true,
                  fillColor: widget.fieldColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: countdown == 0 ? resendCode : null,
                      child: Text(countdown == 0 ? 'Kirim Ulang' : 'Tunggu $countdown dtk'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: verifyCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                    ),
                    child: const Text('Verifikasi'),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sudah punya akun? ', style: TextStyle(color: widget.bottomTextColor)),
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage())),
                  child: Text(
                    'Login di sini',
                    style: TextStyle(color: widget.bottomTextColor2, fontWeight: FontWeight.bold),
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
