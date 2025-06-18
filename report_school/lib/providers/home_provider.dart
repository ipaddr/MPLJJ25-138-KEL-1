import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/laporan.dart';
import '../config/api.dart';

class HomeProvider with ChangeNotifier {
  final List<Laporan> _laporanList = [];
  final List<Laporan> _laporanHariIniList = [];
  final List<Laporan> _laporanListDiterima = [];
  bool _isAdmin = false;

  List<Laporan> get laporanList => _laporanList;
  List<Laporan> get laporanHariIniList => _laporanHariIniList;
  List<Laporan> get laporanListDiterima => _laporanListDiterima;
  bool get isAdmin => _isAdmin;

  // Fungsi Ambil semua laporan
  Future<void> fetchLaporan() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(apiGetLaporan),
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
       
        _laporanList.clear();
        _laporanList.addAll(jsonData.map((item) => Laporan.fromJson(item)).toList());
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

  // Fungsi Ambil Laporan diterima
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
        debugPrint('Berhasil mengambil laporan diterima: ${response.body}');
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> jsonData = decoded['data'];
        debugPrint('decoded["data"] runtimeType: ${decoded["data"].runtimeType}');
        
        _laporanListDiterima.clear();
        _laporanListDiterima.addAll(jsonData.map((item) => Laporan.fromJson(item)).toList());
        notifyListeners();
      } else {
        debugPrint('Gagal mengambil laporan yang diterima: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error saat fetch laporan yang diterima: $e');
    }
  }

  // Fungsi untuk cek apakah Admin atau user
  // Cek Admin
  Future<void> checkIsAdmin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(apiIsAdmin),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        _isAdmin = jsonData['is_admin'] ?? false;
        debugPrint('Cek admin berhasil: $_isAdmin');
      } else {
        debugPrint('Gagal mengecek admin: ${response.body}');
        _isAdmin = false;
      }
    } catch (e) {
      debugPrint('Error saat cek admin: $e');
      _isAdmin = false;
    }

    notifyListeners();
  }

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

  // Fungsi untuk mengam
}
