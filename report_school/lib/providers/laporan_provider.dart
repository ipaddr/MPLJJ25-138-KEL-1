import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:report_school/component/window/dialog_window.dart';
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
  final List<Laporan> _laporanListAll = [];
  final List<Laporan> _laporanHariIniList = [];
  final List<Laporan> _laporanListBelumDiterima = [];

  List<Laporan> get laporanListAll => _laporanListAll;
  List<Laporan> get laporanHariIniList => _laporanHariIniList;
  List<Laporan> get laporanListDiterima => _laporanListDiterima;
  List<Laporan> get laporanListBelumDiterima => _laporanListBelumDiterima;

  // Fungsi Ambil semua laporan
  Future<void> fetchLaporan() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(apiGetLaporanAll),
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
       
        _laporanListAll.clear();
        _laporanListAll.addAll(jsonData.map((item) => Laporan.fromJson(item)).toList());
        notifyListeners();
      } else {
        debugPrint('Gagal mengambil laporan: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error saat fetch laporan: $e');
    }
  }

  // Fungsi Ambil laporan diterima
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

  // Fungsi Ambil laporan hari ini
  Future<void> fetchLaporanHariIni() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(apiGetLaporanHariIni),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Berhasil mengambil laporan hari ini: ${response.body}');
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> jsonData = decoded['data'];
        debugPrint('decoded["data"] runtimeType: ${decoded["data"].runtimeType}');

        _laporanHariIniList.clear();
        _laporanHariIniList.addAll(jsonData.map((item) => Laporan.fromJson(item)).toList());
        notifyListeners();
      } else {
        debugPrint('Gagal mengambil laporan hari ini: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error saat fetch laporan hari ini: $e');
    }
  }

  // Fungsi Ambil laporan belum diterima
  Future<void> fetchLaporanBelumDiterima() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(apiGetLaporanBelumDiterima),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Berhasil mengambil laporan Belum Diterima: ${response.body}');
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> jsonData = decoded['data'];
        debugPrint('decoded["data"] runtimeType: ${decoded["data"].runtimeType}');

        _laporanListBelumDiterima.clear();
        _laporanListBelumDiterima.addAll(jsonData.map((item) => Laporan.fromJson(item)).toList());
         if (jsonData.isEmpty) {
          debugPrint('Tidak ada laporan belum diterima.');
          _laporanListBelumDiterima.clear();
          return;
        }
        notifyListeners();
      } else {
        debugPrint('Gagal mengambil laporan belum diterima: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error saat fetch laporan belum diterima: $e');
    }
  }

  // Fungsi untuk mengirim laporan
  /// Mengirim laporan baru dengan judul, isi, id sekolah, gambar, dan tag foto.
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

  // Fungsi untuk memberikan rating pada laporan
  Future<void> rateLaporan(Laporan laporan, double rating) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final postResponse = await http.post(
        Uri.parse(apiRateLaporan(laporan.id)),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'rating': rating}),
      );

      debugPrint('Response POST rating: ${postResponse.statusCode}');
      debugPrint('Body POST: ${postResponse.body}');

      if (postResponse.statusCode == 200) {
        laporan.updateRating(rating); // cukup update objek lokalnya
        notifyListeners(); // biar UI ke-refresh
      } else {
        debugPrint('Gagal memberikan rating: ${postResponse.body}');
      }
    } catch (e, stackTrace) {
      debugPrint('Error saat memberikan rating: $e');
      debugPrint('StackTrace: $stackTrace');
    }
  }

  // Fungsi untuk memberikan status pada laporan
  // Fungsi untuk memberikan status pada laporan
  Future<void> setLaporanStatus(
  BuildContext context,
  int idLaporan,
  String status,
) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final uri = Uri.parse(apiSetLaporanStatus);

    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    request.fields['id_laporan'] = idLaporan.toString();
    request.fields['status'] = status.toLowerCase();

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      await showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => const Dialog(
          backgroundColor: Colors.transparent,
          child: SystemMessageCardOke(
            message: 'Status laporan berhasil diperbarui.',
          ),
        ),
      );

      // Pop dan beri sinyal agar halaman sebelumnya bisa refresh
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } else {
      final data = jsonDecode(responseBody);
      await showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          child: SystemMessageCardOke(
            message: data['message'] ?? 'Gagal memperbarui status laporan.',
          ),
        ),
      );
    }
  } catch (e) {
    await showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) => const Dialog(
        backgroundColor: Colors.transparent,
        child: SystemMessageCardOke(
          message: 'Terjadi kesalahan saat memperbarui status.',
        ),
      ),
    );
  }
}

  // Fungsi untuk mengambil laporan berdasarkan id progres
  Future<List<Laporan>> fetchLaporanByProgress(int idProgress) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(apiGetLaporanByProgress(idProgress)),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Berhasil mengambil laporan berdasarkan progres: ${response.body}');
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> jsonData = decoded['data'];

        return jsonData.map((item) => Laporan.fromJson(item)).toList();
      } else {
        debugPrint('Gagal mengambil laporan berdasarkan progres: ${response.body}');
        return [];
      }
    } catch (e) {
      debugPrint('Error saat fetch laporan berdasarkan progres: $e');
      return [];
    }
  }
}
