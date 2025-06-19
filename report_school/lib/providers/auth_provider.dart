import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api.dart';

class AuthProvider with ChangeNotifier {
  bool _isAdmin = false;

  // Getter untuk status admin
  bool get isAdmin => _isAdmin;

  // Fungsi untuk cek apakah Admin atau user
  // Cek Admin
  Future<void> checkIsAdmin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(apiIsAdmin),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        _isAdmin = jsonData['is_admin'] ?? false;
        debugPrint('Cek admin berhasil: $_isAdmin');
      } else {
        debugPrint('Gagal mengecek admin: ${response.body}');
        _isAdmin = false;
      }
    } catch (e) {
      debugPrint('Error saat cek admin: $e');
      _isAdmin = false;
    }

    notifyListeners();
  }

}