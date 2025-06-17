import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/file_pendukung.dart';

class FilePendukungProvider with ChangeNotifier {
  final List<FilePendukung> _files = [];

  List<FilePendukung> get gambarList => _files;

  static const String serverIp = "192.168.130.167"; // ganti sesuai IP
  static const String port = "8000";

  String buildImageUrl(String path) {
    if (path.startsWith("http")) return path;
    final cleanedPath = path.replaceFirst("public/", "");
    return "http://$serverIp:$port/storage/$cleanedPath";
  }

  Future<bool> checkImageExists(String url) async {
    for (int attempt = 1; attempt <= 10; attempt++) {
      try {
        final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
        if (response.statusCode == 200) {
          return true;
        } else {
          debugPrint("Percobaan $attempt gagal: Status ${response.statusCode}");
        }
      } catch (e) {
        debugPrint("Percobaan $attempt error: $e");
      }
      await Future.delayed(const Duration(seconds: 2));
    }
    return false;
  }

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
