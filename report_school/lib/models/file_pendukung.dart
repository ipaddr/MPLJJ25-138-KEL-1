import 'dart:typed_data';
import 'tag_foto.dart';

class FilePendukung {
  final String path;
  final Uint8List bytes;
  final TagFoto tag;

  FilePendukung({
    required this.path,
    required this.bytes,
    required this.tag,
  });
}
