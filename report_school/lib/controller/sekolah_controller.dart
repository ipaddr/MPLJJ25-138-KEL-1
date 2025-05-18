import 'package:flutter/material.dart';
import '../models/sekolah.dart'; // Pastikan path ini sesuai lokasi model Sekolah kamu

class SekolahController extends ChangeNotifier {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController isiController = TextEditingController();

  String? _selectedSekolah;
  List<String> _daftarSekolah = [];

  String? get selectedSekolah => _selectedSekolah;
  List<String> get daftarSekolah => _daftarSekolah;

  void setDaftarSekolah(List<Sekolah> sekolahList) {
    _daftarSekolah = sekolahList.map((s) => s.namaSekolah ?? '').toList();
    notifyListeners();
  }

  void updateSelectedSekolah(String? value) {
    _selectedSekolah = value;
    notifyListeners();
  }

  void clearForm() {
    judulController.clear();
    isiController.clear();
    _selectedSekolah = null;
    notifyListeners();
  }

  void loadDummyData() {
    setDaftarSekolah([
      Sekolah(namaSekolah: 'SMAN 1 Jakarta', lokasi: 'Jakarta'),
      Sekolah(namaSekolah: 'SMKN 2 Bandung', lokasi: 'Bandung'),
      Sekolah(namaSekolah: 'SMAN 3 Surabaya', lokasi: 'Surabaya'),
    ]);
  }

  @override
  void dispose() {
    judulController.dispose();
    isiController.dispose();
    super.dispose();
  }
}
