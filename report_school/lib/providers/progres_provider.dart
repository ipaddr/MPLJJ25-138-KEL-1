import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/progres.dart';
import '../../models/tag_foto.dart';
import '../../models/result.dart';
import '../../models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/image_utils.dart';
import '../config/api.dart';

class ProgressProvider with ChangeNotifier {
  List<Progres> _progressList = [];

  List<Progres> get progressList => _progressList;

 Future<Result> kirimProgress({
  required String judul,
  required String isi,
  required String? namaSekolah,
  required List<File>? images,
  required List<TagFoto>? tags,
  required int idLaporan,
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
    request.fields['persen_progress'] = "0.0";
    request.fields['fk_id_laporan'] = idLaporan.toString();

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

  void removeProgress(int index) {
    if (index >= 0 && index < _progressList.length) {
      _progressList.removeAt(index);
      notifyListeners();
    }
  }

  void updateProgress(int index, Progres updatedProgress) {
    if (index >= 0 && index < _progressList.length) {
      _progressList[index] = updatedProgress;
      notifyListeners();
    }
  }

  Progres getProgress(int index) {
    return _progressList[index];
  }

  void clearAllProgress() {
    _progressList.clear();
    notifyListeners();
  }

  void loadDummyData() {
    _progressList = [
      Progres(
        id: 1,
        judul: "Judul Progress 1",
        namaPengirim: "Pengirim 1",
        isi: "Isi dari progress 1",
        persen: 50.0,
        tanggal: DateTime.now().subtract(const Duration(days: 2)),
        user: User(username: "admin"),
      ),
      Progres(
        id: 2,
        judul: "Judul Progress 2",
        namaPengirim: "Pengirim 2",
        isi: "Isi dari progress 2",
        persen: 75.0,
        tanggal: DateTime.now().subtract(const Duration(days: 1)),
        user: User(username: "admin"),
      ),
      Progres(
        id: 3,
        judul: "Judul Progress 3",
        namaPengirim: "Pengirim 3",
        isi: "Isi dari progress 3",
        persen: 100.0,
        tanggal: DateTime.now(),
        user: User(username: "admin"),
      ),
    ];
    notifyListeners();
  }
}
