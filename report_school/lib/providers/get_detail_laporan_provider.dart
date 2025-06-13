import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api.dart';
import '../models/laporan.dart';

class GetDetailLaporanProvider with ChangeNotifier {
  Laporan? _laporan;
  bool _loading = false;
  String? _error;

  Laporan? get laporan => _laporan;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchLaporanDetail(int id) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(apiGetDetailLaporan.replaceFirst('{id}', id.toString())),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${await _getToken()}',
            'Content-Type': 'application/json',
          });
      if (response.statusCode == 200) {
        // debugPrint('Response body: ${response.body}');
        debugPrint('Response status code: ${response.statusCode}');
       
        final jsonBody = jsonDecode(response.body);
         debugPrint('Response body: ${response.body}');
        _laporan = Laporan.fromJson(jsonBody['data']);
      } else {
        _error = 'Gagal mengambil data: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Terjadi kesalahan: $e';
    }

    _loading = false;
    notifyListeners();
  }

  // Add this method to retrieve the token, adjust as needed for your app's storage mechanism
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
}
