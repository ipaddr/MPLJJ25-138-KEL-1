import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/sekolah.dart';
import '../config/api.dart'; // pastikan path sesuai

class SekolahController extends ChangeNotifier {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController isiController = TextEditingController();

  String? _selectedSekolah;
  List<Sekolah> _daftarSekolah = [];

  String? get selectedSekolah => _selectedSekolah;
  List<String> get daftarSekolah =>
      _daftarSekolah.map((s) => s.namaSekolah ?? '').toList();

  void updateSelectedSekolah(String? value) {
    _selectedSekolah = value;
    notifyListeners();
  }

  Future<void> fetchSekolah() async {
    try {
      final response = await http.get(Uri.parse(apiGetSekolah), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer TOKEN', // Ganti dengan token yang valid
      });

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _daftarSekolah = data.map((e) => Sekolah.fromJson(e)).toList();
        notifyListeners();
      } else {
        debugPrint('Gagal fetch sekolah: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetch sekolah: $e');
    }
  }

  void clearForm() {
    judulController.clear();
    isiController.clear();
    _selectedSekolah = null;
    notifyListeners();
  }

  @override
  void dispose() {
    judulController.dispose();
    isiController.dispose();
    super.dispose();
  }
}
