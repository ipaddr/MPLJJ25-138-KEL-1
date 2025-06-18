import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

Future<File> compressImage(File file) async {
  final dir = await getTemporaryDirectory();
  final targetPath = path.join(dir.path, '${DateTime.now().millisecondsSinceEpoch}.jpg');

  final result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 20,
    format: CompressFormat.jpeg,
  );

  return result != null ? File(result.path) : file;
}
// TODO Implement this library.