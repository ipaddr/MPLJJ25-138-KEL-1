import 'package:flutter/material.dart';
import '../models/pengumuman.dart';
import '../models/foto_path.dart';

class PengumumanProvider with ChangeNotifier {
  // List untuk menyimpan pengumuman
  List<Pengumuman> _pengumumanList = [];

  // Getter untuk mendapatkan list pengumuman
  List<Pengumuman> get pengumumanList => _pengumumanList;

  // Menambahkan data dummy
  void addDummyPengumuman() {
    _pengumumanList = [
    Pengumuman(
      judul: 'Pengumuman Penting 1',
      deskripsi: 'Deskripsi pengumuman pertama, yang berisi informasi penting.',
      tanggal: DateTime.now(),
      foto: FotoPath(
        AssetImage("assets/dataDummy/pengumuman_dummy.jpg"),
        caption: 'Foto pengumuman 1',
      ),
    ),
];

    notifyListeners(); // Memberi tahu bahwa data telah diperbarui
  }
}