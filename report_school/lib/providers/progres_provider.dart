import 'package:flutter/material.dart';
import '../../models/progres.dart';

class ProgressProvider with ChangeNotifier {
  List<Progres> _progressList = [];

  List<Progres> get progressList => _progressList;

  // Method untuk menambahkan progress baru
  void addProgress(Progres newProgress) {
    _progressList.add(newProgress);
    notifyListeners();
  }

  // Method untuk menghapus progress
  void removeProgress(int index) {
    if (index >= 0 && index < _progressList.length) {
      _progressList.removeAt(index);
      notifyListeners();
    }
  }

  // Method untuk update progress
  void updateProgress(int index, Progres updatedProgress) {
    if (index >= 0 && index < _progressList.length) {
      _progressList[index] = updatedProgress;
      notifyListeners();
    }
  }

  // Method untuk mendapatkan progress berdasarkan index
  Progres getProgress(int index) {
    return _progressList[index];
  }

  // Method untuk mengosongkan semua progress
  void clearAllProgress() {
    _progressList.clear();
    notifyListeners();
  }

  // Method untuk mengisi data dummy (untuk testing)
  void loadDummyData() {
    _progressList = [
      Progres(
        judul: "Judul Progress 1",
        namaPengirim: "Pengirim 1",
        tanggal: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Progres(
        judul: "Judul Progress 2",
        namaPengirim: "Pengirim 2",
        tanggal: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Progres(
        judul: "Judul Progress 3",
        namaPengirim: "Pengirim 3",
        tanggal: DateTime.now(),
      ),
    ];
    notifyListeners();
  }
}