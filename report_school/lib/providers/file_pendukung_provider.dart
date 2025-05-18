import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/file_pendukung.dart';

class FilePendukungProvider with ChangeNotifier {
  final List<FilePendukung> _files = [];

  List<FilePendukung> get gambarList =>
      _files.where((f) => f.tipe == FileTypePendukung.gambar).toList();

  Future<void> tambahGambarDariGaleri() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        _files.add(
          FilePendukung(
            path: file.path ?? '', // Web kadang null path, bisa simpan `file.bytes` kalau perlu
            tipe: FileTypePendukung.gambar,
          ),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Gagal memilih gambar: $e");
    }
  }
}
