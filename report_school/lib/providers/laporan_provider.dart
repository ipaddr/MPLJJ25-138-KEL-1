import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/laporan.dart';
import '../models/tag_foto.dart';
import '../utils/image_utils.dart';
import '../config/api.dart';

class LaporanResult {
  final bool success;
  final String? message;

  LaporanResult({required this.success, this.message});
}

class LaporanProvider with ChangeNotifier {
  final List<Laporan> _laporanListDiterima = [];

  List<Laporan> get laporanListDiterima => _laporanListDiterima;

  Future<void> fetchLaporanDiterima() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(apiGetLaporanDiterima),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Berhasil mengambil laporan: ${response.body}');
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> jsonData = decoded['data'];

        _laporanListDiterima.clear();
        _laporanListDiterima.addAll(jsonData.map((item) => Laporan.fromJson(item)).toList());
        notifyListeners();
      } else {
        debugPrint('Gagal mengambil laporan: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error saat fetch laporan: $e');
    }
  }

  Future<LaporanResult> kirimLaporan({
    required String judul,
    required String isi,
    required int? idSekolah,
    required List<File> images,
    required List<TagFoto> tags,
  }) async {
    if (judul.isEmpty || isi.isEmpty || idSekolah == null) {
      return LaporanResult(success: false, message: 'Semua field wajib diisi.');
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final uri = Uri.parse(apiCreateLaporan);

      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      request.fields['judul_laporan'] = judul;
      request.fields['isi_laporan'] = isi;
      request.fields['fk_id_sekolah'] = idSekolah.toString();
      request.fields['tanggal_pelaporan'] = DateTime.now().toIso8601String();

      for (int i = 0; i < images.length; i++) {
        final compressed = await compressImage(images[i]);
        request.files.add(await http.MultipartFile.fromPath('foto[]', compressed.path));
        request.fields['tag_foto[$i]'] = tags[i].namaTag;
      }

      final response = await request.send();
      final body = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        return LaporanResult(success: true);
      } else {
        final data = jsonDecode(body);
        return LaporanResult(success: false, message: data['message'] ?? 'Gagal mengirim laporan.');
      }
    } catch (e) {
      return LaporanResult(success: false, message: 'Terjadi kesalahan koneksi.');
    }
  }
}
