import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api.dart';
import '../models/laporan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressController extends ChangeNotifier {
  final TextEditingController judulProgress = TextEditingController();
  final TextEditingController isiProgress = TextEditingController();

  List<Laporan> _daftarLaporan = [];
  Laporan? _selectedLaporan;

  List<Laporan> get daftarLaporan => _daftarLaporan;
  Laporan? get selectedLaporan => _selectedLaporan;
  int? get selectedIdLaporan => _selectedLaporan?.id;
  List<String> get daftarJudulLaporan => _daftarLaporan.map((l) => l.judul).toList();

  // Fetch laporan dari API (bisa diganti ke laporan diterima jika perlu)
  Future<void> fetchLaporan() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return;

      final response = await http.get(
        Uri.parse(apiGetLaporanDiterima),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> jsonData = decoded['data'];
        _daftarLaporan = jsonData.map((item) => Laporan.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error saat fetch laporan (progress): $e');
    }
  }

  void updateSelectedLaporanByJudul(String? judul) {
    if (_daftarLaporan.isNotEmpty && judul != null) {
      _selectedLaporan = _daftarLaporan.firstWhere(
        (l) => l.judul == judul,
        orElse: () => _daftarLaporan.first,
      );
    } else {
      _selectedLaporan = null;
    }
    notifyListeners();
  }

  void updateSelectedLaporanById(int? id) {
    if (_daftarLaporan.isNotEmpty && id != null) {
      _selectedLaporan = _daftarLaporan.firstWhere(
        (l) => l.id == id,
        orElse: () => _daftarLaporan.first,
      );
    } else {
      _selectedLaporan = null;
    }
    notifyListeners();
  }

  void clearForm() {
    judulProgress.clear();
    isiProgress.clear();
    _selectedLaporan = null;
    notifyListeners();
  }
}