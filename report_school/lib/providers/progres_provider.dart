import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/progres.dart';
import '../../models/tag_foto.dart';
import '../../models/result.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/image_utils.dart';
import '../config/api.dart';
import '../../models/laporan.dart';

class ProgressProvider with ChangeNotifier {
  final List<Progres> _progressList = [];
  final List<Laporan> _laporanListDiterima = [];
  final List<Progres> _progressListSelesai = [];

  List<Progres> get progressList => _progressList;
  List<Laporan> get laporanListDiterima => _laporanListDiterima;
  List<Progres> get progressListSelesai => _progressListSelesai;

  Future<Result> kirimProgress({
    required String judul,
    required String isi,
    required List<File>? images,
    required List<TagFoto>? tags,
    List<int?>? idLaporan,
    required double persenProgress,
    int? idProgressSebelumnya,
  }) async {
    if (judul.trim().isEmpty || isi.trim().isEmpty) {
      return Result(success: false, message: "Semua field wajib diisi.");
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final uri = Uri.parse(apiCreateProgress);

      final request = http.MultipartRequest("POST", uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Isi data form
      request.fields['nama_progress'] = judul;
      request.fields['isi_progress'] = isi;
      request.fields['tanggal_progress'] = DateTime.now().toIso8601String();
      request.fields['persen_progress'] = persenProgress.toString();
      request.fields['fk_id_progress_sebelumnya'] = idProgressSebelumnya?.toString() ?? '';

      if(idLaporan?.isNotEmpty == true){
        int index = 0;
        for (int? id in idLaporan!) {
          if (id != null && id > 0) {
            request.fields['fk_id_laporan[$index]'] = id.toString();
             debugPrint('ID Laporan Terkait: $idLaporan[$index]');
            index++;
          }
        }
      } 

      if (idProgressSebelumnya != null) {
        request.fields['fk_id_progress_sebelumnya'] = idProgressSebelumnya.toString();
      }

      // Upload file dan tag
      if (images != null && images.isNotEmpty && tags != null && tags.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          final compressed = await compressImage(images[i]);
            request.files.add(await http.MultipartFile.fromPath('fotos[$i]', compressed.path));
            request.fields['tags[$i]'] = tags[i].namaTag;
        }
      } 

      final response = await request.send();
      final body = await response.stream.bytesToString();

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Result(success: true, message: "Progress berhasil dikirim.");
      } else {
        final data = jsonDecode(body);
        return Result(success: false, message: data['message'] ?? "Gagal mengirim progress.");
      }
    } catch (e) {
      return Result(success: false, message: "Terjadi kesalahan: $e");
    }
  }

  void addProgress(Progres newProgress) {
    _progressList.add(newProgress);
    notifyListeners();
  }

  // Fetch progress dari API
  Future<void> fetchProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(apiGetProgress),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Berhasil mengambil progress: ${response.body}');
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> jsonData = decoded['data'];

        _progressList.clear();
        _progressList.addAll(jsonData.map((item) => Progres.fromJson(item)).toList());

        notifyListeners();
      } else {
        debugPrint('Gagal mengambil progress: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error saat fetch progress: $e');
    }
  }

  // Fetch progress selesai dari API
  Future<void> fetchProgressSelesai() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(apiGetProgressSelesai),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Berhasil mengambil progress selesai: ${response.body}');
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> jsonData = decoded['data'];

        _progressListSelesai.clear();
        _progressListSelesai.addAll(jsonData.map((item) => Progres.fromJson(item)).toList());

        notifyListeners();
      } else {
        debugPrint('Gagal mengambil progress selesai: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error saat fetch progress selesai: $e');
    }
  }

}
