import 'dart:typed_data';
import 'tag_foto.dart';
import 'package:flutter/foundation.dart';
import '../config/api.dart';

class FilePendukung {
  final String path;
  final Uint8List bytes;
  final TagFoto tag;

  static const String serverIp = hostFilePendukung;
  static const String port = portFilePendukung;

  FilePendukung({
    required this.path,
    required this.bytes,
    required this.tag,
  });

}
