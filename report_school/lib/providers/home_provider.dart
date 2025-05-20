import 'package:flutter/material.dart';
import '../models/laporan.dart';

class HomeProvider with ChangeNotifier {
  final List<Laporan> _laporanList = [];

  List<Laporan> get laporanList => _laporanList;
  
  void addDummyData() {
    _laporanList.addAll([
      Laporan(
        judul: 'Kerusakan Atap',
        deskripsi: 'Atap bocor saat hujan.',
        namaPengirim: 'Pak Rudi',
        tanggal: DateTime(2025, 12, 23),
      ),
      Laporan(
        judul: 'Meja Tidak Cukup',
        deskripsi: 'Kursi dan meja tidak memadai.',
        namaPengirim: 'Bu Ani',
        tanggal: DateTime(2025, 12, 22),
      ),
    ]);
    notifyListeners();
  }

  void updateRating(Laporan laporan, double newRating) {
    laporan.rating = newRating;
    notifyListeners();
  }
}
