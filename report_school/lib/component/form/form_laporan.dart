import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:report_school/config/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:report_school/controller/sekolah_controller.dart';
import 'package:provider/provider.dart';
import '../window/insert_gambar_window.dart';
import '../../models/tag_foto.dart';
import '../../component/window/konfirmasi_window.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class LaporanFormCard extends StatefulWidget {
  final TextEditingController judulController;
  final TextEditingController isiController;
  final String? selectedSekolah;
  final List<String> daftarSekolah;
  final Function(String?) onSekolahChanged;

  const LaporanFormCard({
    super.key,
    required this.judulController,
    required this.isiController,
    required this.selectedSekolah,
    required this.daftarSekolah,
    required this.onSekolahChanged,
  });

  @override
  State<LaporanFormCard> createState() => _LaporanFormCardState();
}

class _LaporanFormCardState extends State<LaporanFormCard> {
  final List<File> _selectedImages = [];
  final List<TagFoto> _selectedTags = [];
  bool isSubmitting = false;
  String? errorMessage;

  Future<File> compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = path.join(dir.path, '${DateTime.now().millisecondsSinceEpoch}.jpg');

    final XFile? result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 20, // Kualitas 20% untuk kompresi
      format: CompressFormat.jpeg,
    );

    // Convert XFile to File jika tidak null
    return result != null ? File(result.path) : file;
  }

  Future<void> pickImagesWithWindow() async {
    await showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: UploadDokumenWindow(
          onSubmit: (File image, TagFoto tag) {
            setState(() {
              _selectedImages.add(image);
              _selectedTags.add(tag);
            });
          },
        ),
      ),
    );
  }

  Future<void> _confirmDelete(int index) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: SystemMessageCard(
          message: 'Yakin ingin menghapus gambar ini?',
          yesText: 'Ya, hapus',
          noText: 'Batal',
        ),
      ),
    );

    if (result == true) {
      setState(() {
        _selectedImages.removeAt(index);
        _selectedTags.removeAt(index);
      });
    }
  }

  Future<void> submitForm() async {
    if (widget.judulController.text.isEmpty ||
        widget.isiController.text.isEmpty ||
        widget.selectedSekolah == null) {
      setState(() => errorMessage = 'Semua field wajib diisi.');
      return;
    }

    setState(() {
      isSubmitting = true;
      errorMessage = null;
    });

    final sekolahCtrl = Provider.of<SekolahController>(context, listen: false);
    final selectedId = sekolahCtrl.getSelectedSekolahId();
    if (selectedId == null) {
      setState(() => errorMessage = 'Sekolah tidak valid.');
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final uri = Uri.parse(apiCreateLaporan);
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['judul_laporan'] = widget.judulController.text;
      request.fields['isi_laporan'] = widget.isiController.text;
      request.fields['fk_id_sekolah'] = selectedId.toString();
      request.fields['tanggal_pelaporan'] = DateTime.now().toIso8601String();

      for (int i = 0; i < _selectedImages.length; i++) {
        final image = _selectedImages[i];
        final tag = _selectedTags[i];
        //request.files.add(await http.MultipartFile.fromPath('foto[]', image.path));
        final compressed = await compressImage(image);
        request.files.add(await http.MultipartFile.fromPath('foto[]', compressed.path));
        request.fields['tag_foto[$i]'] = tag.namaTag;
      }

      final response = await request.send();

      if (response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Laporan berhasil dikirim.')),
          );
        }
        widget.judulController.clear();
        widget.isiController.clear();
        setState(() {
          _selectedImages.clear();
          _selectedTags.clear();
        });
      } else {
        final body = await response.stream.bytesToString();
        final data = jsonDecode(body);
        setState(() => errorMessage = data['message'] ?? 'Gagal mengirim laporan.');
      }
    } catch (e) {
      debugPrint('Error submitting form: $e');
      setState(() => errorMessage = 'Terjadi kesalahan koneksi.');
    }

    setState(() => isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Informasi Umum', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 10),

        if (errorMessage != null)
          Text(errorMessage!, style: const TextStyle(color: Colors.red)),

        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                TextField(
                  controller: widget.judulController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Laporan',
                    hintText: 'contoh nama laporan...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: widget.selectedSekolah,
                  items: widget.daftarSekolah.map((sekolah) {
                    return DropdownMenuItem(value: sekolah, child: Text(sekolah));
                  }).toList(),
                  onChanged: widget.onSekolahChanged,
                  decoration: const InputDecoration(
                    labelText: 'Pilih Sekolah',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: TextField(
              controller: widget.isiController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Isi Laporan',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),
        const Text('File Pendukung', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

        ElevatedButton.icon(
          onPressed: pickImagesWithWindow,
          icon: const Icon(Icons.image),
          label: const Text('Pilih Gambar'),
        ),

        const SizedBox(height: 10),

        if (_selectedImages.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_selectedImages.length, (index) {
              return Stack(
                children: [
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _selectedImages[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(_selectedTags[index].namaTag, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () => _confirmDelete(index),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton.icon(
            onPressed: isSubmitting ? null : submitForm,
            icon: isSubmitting
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.send),
            label: const Text('Kirim Laporan'),
          ),
        ),
      ],
    );
  }
}
