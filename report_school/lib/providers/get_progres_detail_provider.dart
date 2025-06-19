import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api.dart';
import '../models/progres.dart';

class GetDetailProgresProvider with ChangeNotifier {
  Progres? _progres;
  bool _loading = false;
  String? _error;

  Progres? get progres => _progres;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchProgresDetail(int id) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _getToken();

      final url = Uri.parse(apiGetDetailProgress.replaceFirst('{id}', id.toString()));
      debugPrint("Requesting detail progres: $url");

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        
        if (jsonBody['data'] == null) {
          _error = 'Data progres tidak ditemukan.';
          _progres = null;
        } else {
          _progres = Progres.fromJson(jsonBody['data']);
          _error = null;
        }
      } else {
        _error = 'Gagal mengambil data: ${response.statusCode}';
        _progres = null;
      }
    } catch (e) {
      _error = 'Terjadi kesalahan: $e';
      _progres = null;
      debugPrintStack(label: 'Error fetching progress detail', stackTrace: StackTrace.current);
    }

    _loading = false;
    notifyListeners();
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
}
