import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api.dart';
import '../models/sekolah.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SekolahController extends ChangeNotifier {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController isiController = TextEditingController();

  Sekolah? _selectedSekolah;
  List<Sekolah> _daftarSekolah = [];

  Sekolah? get selectedSekolah => _selectedSekolah;
  List<Sekolah> get daftarSekolah => _daftarSekolah;
  List<String> get daftarNamaSekolah => _daftarSekolah.map((s) => s.namaSekolah ?? '').toList();

  Future<void> fetchSekolah() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        debugPrint('Token tidak ditemukan.');
        return;
      }

      final response = await http.get(
        Uri.parse(apiGetSekolah),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // <--- ini penting
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Berhasil fetch sekolah');
         // Decode JSON response
        final List jsonData = jsonDecode(response.body);
        _daftarSekolah = jsonData.map((item) => Sekolah.fromJson(item)).toList();
        notifyListeners();
      } else {
        debugPrint('Gagal: ${response.body}');
      }
    } catch (e) {
      debugPrint('Gagal fetch sekolah: $e');
    }
  }


  void updateSelectedSekolah(String? nama) {
    if (_daftarSekolah.isNotEmpty) {
      _selectedSekolah = _daftarSekolah.firstWhere(
        (s) => s.namaSekolah == nama,
        orElse: () => _daftarSekolah.first,
      );
    } else {
      _selectedSekolah = null;
    }
    notifyListeners();
  }

  void clearForm() {
    judulController.clear();
    isiController.clear();
    _selectedSekolah = null;
    notifyListeners();
  }

  String? get selectedNamaSekolah => _selectedSekolah?.namaSekolah;
  int? get selectedIdSekolah => _selectedSekolah?.idSekolah;

  int? getSelectedSekolahId() {
    final sekolah = _daftarSekolah.firstWhere(
      (s) => s.namaSekolah == _selectedSekolah?.namaSekolah,
      orElse: () => Sekolah(idSekolah: null, namaSekolah: '', lokasi: ''),
    );
    return sekolah.idSekolah;
  }
}
