import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:report_school/component/window/dialog_window.dart';
import 'package:report_school/controller/laporan_controller.dart';
import 'package:report_school/models/tag_foto.dart';
import 'package:report_school/component/window/konfirmasi_window.dart';
import 'package:report_school/component/window/insert_gambar_window.dart';
import 'package:report_school/providers/laporan_provider.dart';
import 'package:report_school/utils/dialog_helper.dart';
import 'package:report_school/theme/app_theme.dart';

class LaporanFormCard extends StatefulWidget {
  final TextEditingController judulLaporan;
  final TextEditingController isiLaporan;
  final String? selectedSekolah;
  final List<String> daftarSekolah;
  final Function(String?) onSekolahChanged;

  const LaporanFormCard({
    super.key,
    required this.judulLaporan,
    required this.isiLaporan,
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

  // UI 
  double cardRadius = 16;

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
    final sekolahCtrl = Provider.of<LaporanController>(context, listen: false);
    final laporanProvider = Provider.of<LaporanProvider>(context, listen: false);
    final selectedId = sekolahCtrl.getSelectedSekolahId();

    setState(() {
      isSubmitting = true;
      errorMessage = null;
    });

    final result = await laporanProvider.kirimLaporan(
      judul: widget.judulLaporan.text,
      isi: widget.isiLaporan.text,
      idSekolah: selectedId,
      images: _selectedImages,
      tags: _selectedTags,
    );

    if (result.success) {
      widget.judulLaporan.clear();
      sekolahCtrl.updateSelectedSekolah(null); // Reset pilihan sekolah
      widget.isiLaporan.clear();
      setState(() {
        _selectedImages.clear();
        _selectedTags.clear();
      });
      // Window untuk konfirmasi pengiriman laporan
      await Future.delayed(const Duration(milliseconds: 100));
      // Tampilkan dialog konfirmasi
      
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          child: SystemMessageCardOke(
            message: 'Laporan berhasil dikirim',
          ),
        ),
      );
    } else {
      setState(() {
        errorMessage = result.message;
      });
    }

    setState(() => isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        DialogHelper.showErrorDialog(
          context: context,
          message: errorMessage!,
          onClose: () => setState(() => errorMessage = null),
        );
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text('Informasi Umum', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        const SizedBox(height: 10),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                TextField(
                  controller: widget.judulLaporan,
                  decoration: const InputDecoration(
                    labelText: 'Judul Laporan',
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: widget.selectedSekolah,
                  items: widget.daftarSekolah.map((sekolah) {
                    return DropdownMenuItem(
                      value: sekolah, // pakai nama langsung
                      child: Text(sekolah),
                    );
                  }).toList(),
                  onChanged: widget.onSekolahChanged,
                  decoration: const InputDecoration(
                    labelText: 'Pilih Sekolah',
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: widget.isiLaporan,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: 'Isi Laporan',
                    border: UnderlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text('File Pendukung', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        
        const SizedBox(height: 10),

        // Button untuk memilih gambar
        Container(
          height: 50, // Tinggi tombol
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: ElevatedButton.icon(
            onPressed: pickImagesWithWindow,
            icon: const Icon(Icons.image),
            label: const Text(
              'Pilih Gambar',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.blueCard,
              iconColor: Colors.white,
              shape: RoundedRectangleBorder(
                
                borderRadius: BorderRadius.circular(cardRadius),
              ),
            ),
          ),
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

        // Tombol untuk mengirim laporan
        Container(
          height: 50, // Tinggi tombol
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: ElevatedButton.icon(
            onPressed: isSubmitting ? null : submitForm,
            icon: isSubmitting
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.send),
            label: const Text(
              'Kirim Laporan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.greenCard,
              iconColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cardRadius),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
