import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/laporan.dart';
import '../config/api.dart';

class HomeProvider with ChangeNotifier {
  final List<Laporan> _laporanList = [];

  List<Laporan> get laporanList => _laporanList;

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
        final List jsonData = jsonDecode(response.body);

        _laporanList.clear();
        _laporanList.addAll(jsonData.map((item) => Laporan.fromJson(item)));
        notifyListeners();
      } else {
        debugPrint('Gagal mengambil laporan: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error saat fetch laporan: $e');
    }
  }

  void updateRating(Laporan laporan, double newRating) {
    laporan.rating = newRating;
    notifyListeners();
  }
}
