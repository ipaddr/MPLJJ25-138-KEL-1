import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:report_school/models/tag_foto.dart';
import 'package:report_school/providers/progres_provider.dart';
import 'package:report_school/utils/dialog_helper.dart';
import 'package:report_school/providers/laporan_provider.dart';
import 'package:report_school/component/window/konfirmasi_window.dart';
import 'package:report_school/component/window/insert_gambar_window.dart';

class LaporanProgresCard extends StatefulWidget {
  final TextEditingController judulController;
  final TextEditingController isiController;
  final String? selectedSekolah;
  final List<String> daftarSekolah;
  final Function(String?) onLaporanChanged;

  const LaporanProgresCard({
    super.key,
    required this.judulController,
    required this.isiController,
    required this.selectedSekolah,
    required this.daftarSekolah,
    required this.onLaporanChanged,
  });

  @override
  State<LaporanProgresCard> createState() => _LaporanProgresCardState();
}

class _LaporanProgresCardState extends State<LaporanProgresCard> {
  bool isSubmitting = false;
  String? errorMessage;
  int? selectedLaporanId;

  final List<File> _selectedImages = [];
  final List<TagFoto> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        // ignore: use_build_context_synchronously
        Provider.of<LaporanProvider>(context, listen: false).fetchLaporanDiterima());
  }

  Future<void> submitProgress() async {
    final progresProvider = Provider.of<ProgressProvider>(context, listen: false);

    setState(() {
      isSubmitting = true;
      errorMessage = null;
    });

    if (selectedLaporanId == null) {
      setState(() {
        errorMessage = 'Pilih laporan terlebih dahulu.';
        isSubmitting = false;
      });
      return;
    }

    final result = await progresProvider.kirimProgress(
      judul: widget.judulController.text,
      isi: widget.isiController.text,
      namaSekolah: widget.selectedSekolah,
      images: _selectedImages,
      tags: _selectedTags,
      idLaporan: selectedLaporanId!,
    );

    if (result.success) {
      widget.onLaporanChanged(null);
      widget.judulController.clear();
      widget.isiController.clear();
      setState(() {
        _selectedImages.clear();
        _selectedTags.clear();
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Progres berhasil dikirim.')),
      );
    } else {
      debugPrint("Error: ${result.message}");
      setState(() => errorMessage = result.message);
    }

    setState(() => isSubmitting = false);
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
  
  @override
  Widget build(BuildContext context) {
    final laporanProvider = Provider.of<LaporanProvider>(context);
    final laporanList = laporanProvider.laporanListDiterima;

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
      children: [
        const Text('Tambah Progres', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 10),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                DropdownButtonFormField<int>(
                  value: selectedLaporanId,
                  items: laporanList.map((laporan) {
                    return DropdownMenuItem(
                      value: laporan.id,
                      child: Text(laporan.judul),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLaporanId = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Pilih Laporan Diterima',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    ),
                    onPressed: () {
                      // aksi tambahan bila perlu, contoh: navigasi ke detail
                    },
                    child: const Text('Tambah Laporan Diterima'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Informasi Progres Laporan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 10),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: TextField(
              controller: widget.judulController,
              decoration: const InputDecoration(
                labelText: 'Judul Progres Laporan',
                hintText: 'Contoh nama progres...',
                border: OutlineInputBorder(),
              ),
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
                labelText: 'Isi Progres Laporan',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('File Pendukung', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 10),
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
          height: 45,
          child: ElevatedButton.icon(
            onPressed: isSubmitting ? null : submitProgress,
            icon: isSubmitting
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.send),
            label: const Text('Kirim Progres'),
          ),
        ),
      ],
    );
  }
}
