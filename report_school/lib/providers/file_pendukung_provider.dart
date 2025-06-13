import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import '../../models/file_pendukung.dart';
import '../../models/tag_foto.dart';

class FilePendukungProvider with ChangeNotifier {
  final List<FilePendukung> _files = [];

  List<FilePendukung> get gambarList => _files;

  /// Tambahkan file dari FilePicker (jika kamu ingin pakai FilePicker manual)
  Future<void> tambahGambarDariGaleri({TagFoto? tagOverride}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        _files.add(
          FilePendukung(
            path: file.path ?? '',
            bytes: file.bytes ?? Uint8List(0),
            tag: tagOverride ?? TagFoto(
              id: 0,
              namaTag: "Default Tag"),
          ),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Gagal memilih gambar: $e");
    }
  }

  /// Dipakai saat submit dari `UploadDokumenWindow`
  void addFile(FilePendukung file) {
    _files.add(file);
    notifyListeners();
  }

  void tambahGambar(FilePendukung file) {
    _files.add(file);
    notifyListeners();
  }
  
  void removeAt(int index) {
    if (index >= 0 && index < _files.length) {
      _files.removeAt(index);
      notifyListeners();
    }
  }

  void clear() {
    _files.clear();
    notifyListeners();
  }
}
