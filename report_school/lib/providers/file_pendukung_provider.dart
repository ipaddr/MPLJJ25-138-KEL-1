import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/file_pendukung.dart';
import '../config/api.dart';
import '../../models/tag_foto.dart';
import 'package:collection/collection.dart'; // Untuk firstWhereOrNull


class FilePendukungProvider with ChangeNotifier {
  final List<FilePendukung> _files = []; // untuk upload manual
  final Map<int, List<FilePendukung>> _cacheByLaporan = {}; // untuk cache otomatis
  final Map<int, List<FilePendukung>> _cacheProgress = {}; // untuk cache progress

  List<FilePendukung> get gambarList => _files;

  static const String serverIp = hostFilePendukung;
  static const String port = portFilePendukung;

  // Mengambil URL gambar dari path
  String buildImageUrl(String path) {
    if (path.startsWith("http")) return path;
    final cleanedPath = path.replaceFirst("public/", "");
    return "http://$serverIp:$port/storage/$cleanedPath";
  }

  /// Cek apakah path ini sudah ada di cache
  bool isPathCached(int idLaporan, String path) {
    final cache = _cacheByLaporan[idLaporan];
    if (cache == null) return false;
    return cache.any((f) => f.path == path);
  }

  /// Ambil data file dari cache (jika ada)
  FilePendukung? getCachedFile(int idLaporan, String path) {
    final cache = _cacheByLaporan[idLaporan];
    return cache?.firstWhereOrNull((f) => f.path == path);
  }

  /// Getter untuk mengambil semua file cache berdasarkan laporan
  List<FilePendukung>? getCache(int idLaporan) {
    return _cacheByLaporan[idLaporan];
  }

  /// Cek dan simpan ke cache jika ditemukan
  Future<bool> checkImageExists(String url, int idLaporan, String path, TagFoto tag) async {
    // Cek apakah path ini sudah ada di cache
    if (isPathCached(idLaporan, path)) {
      return true;
    }

    for (int attempt = 1; attempt <= 10; attempt++) {
      try {
        final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
        if (response.statusCode == 200) {
          final bytes = response.bodyBytes;
          final file = FilePendukung(path: path, bytes: bytes, tag: tag);
          _cacheByLaporan.putIfAbsent(idLaporan, () => []).add(file);
          notifyListeners();
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

  // Tambah file ke cache khusus progress
  List<FilePendukung>? getCacheProgress(int idProgress) {
    return _cacheProgress[idProgress];
  }

  Future<bool> checkImageExistsForProgress(
    String url,
    int idProgress,
    String path,
    TagFoto tag,
  ) async {
    // Cek apakah path ini sudah ada di cache
    if (isPathCachedForProgress(idProgress, path)){
      return true;
    }

    for (int attempt = 1; attempt <= 10; attempt++) {
      try {
        final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
        if (response.statusCode == 200) {
          final bytes = response.bodyBytes;
          final file = FilePendukung(path: path, bytes: bytes, tag: tag);
          _cacheProgress.putIfAbsent(idProgress, () => []).add(file);
          notifyListeners();
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

  bool isPathCachedForProgress(int idProgress, String path) {
    final cache = _cacheProgress[idProgress];
    if (cache == null) return false;
    return cache.any((f) => f.path == path);
  }


  // Fungsi upload (tidak terkait dengan cache)
  void tambahGambar(FilePendukung file) {
    _files.add(file);
    notifyListeners();
  }
}
