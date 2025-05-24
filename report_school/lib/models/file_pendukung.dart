import 'dart:typed_data';
enum FileTypePendukung { gambar}

class FilePendukung {
  final String path;
  final FileTypePendukung tipe;
   final Uint8List bytes; 

  FilePendukung({
    required this.path,
    required this.tipe,
    required this.bytes,
  });
}
