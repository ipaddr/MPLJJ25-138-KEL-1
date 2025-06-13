import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api.dart';
import '../models/tag_foto.dart';

class TagFotoController extends ChangeNotifier {
  List<TagFoto> _tags = [];
  TagFoto? _selectedTag;

  List<TagFoto> get tags => _tags;
  TagFoto? get selectedTag => _selectedTag;

  void selectTag(TagFoto? tag) {
    _selectedTag = tag;
    notifyListeners();
  }

  void clearSelectedTag() {
    _selectedTag = null;
    notifyListeners();
  }

  Future<void> fetchTags() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(apiGetTagFoto),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        _tags = data.map((item) => TagFoto.fromJson(item)).toList();
        notifyListeners();
      } else {
        debugPrint('Gagal ambil tag: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetch tag: $e');
    }
  }

  Future<bool> addTag(String namaTag) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse(apiCreateTagFoto),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nama_tag': namaTag,
        }),
      );

      if (response.statusCode == 201) {
        await fetchTags();
        return true;
      } else {
        debugPrint('Gagal tambah tag: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error tambah tag: $e');
    }
    return false;
  }

  void reset() {
    _tags.clear();
    _selectedTag = null;
    notifyListeners();
  }
}
