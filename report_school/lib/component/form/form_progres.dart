import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:report_school/models/tag_foto.dart';
import 'package:report_school/providers/progres_provider.dart';
import 'package:report_school/utils/dialog_helper.dart';
import 'package:report_school/providers/laporan_provider.dart';
import 'package:report_school/component/window/konfirmasi_window.dart';
import 'package:report_school/component/window/insert_gambar_window.dart';
import '../../theme/app_theme.dart';
import 'package:report_school/component/window/dialog_window.dart';

class LaporanProgresCard extends StatefulWidget {
  final TextEditingController judulProgress;
  final TextEditingController isiProgress;
  final String? selectedLaporan;
  final List<String> daftarLaporan;
  final Function(String?) onLaporanChanged;
  
  final dynamic persenProgress;

  const LaporanProgresCard({
    super.key,
    required this.judulProgress,
    required this.isiProgress,
    required this.selectedLaporan,
    required this.daftarLaporan,
    required this.onLaporanChanged,
    this.persenProgress = 0.0,
  });

  @override
  State<LaporanProgresCard> createState() => _LaporanProgresCardState();
}

class _LaporanProgresCardState extends State<LaporanProgresCard> {
  bool isSubmitting = false;
  String? errorMessage;
  List<int?> selectedLaporanIds = [];
  // Untuk menyimpan progres terkait
  int? idProgressSebelumnya;

  final List<File> _selectedImages = [];
  final List<TagFoto> _selectedTags = [];

  final TextEditingController _persenController = TextEditingController();

  // UI
  double cardRadius = 16;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      _refresh()
    );

      _persenController.text = widget.persenProgress.toString(); // default dari widget
  }

  Future<void> submitProgress() async {
    final progresProvider = Provider.of<ProgressProvider>(context, listen: false);

    setState(() {
      isSubmitting = true;
      errorMessage = null;
    });

    // Validasi judul dan isi progres tidak boleh kosong
    if (widget.judulProgress.text.isEmpty || widget.isiProgress.text.isEmpty) {
      setState(() {
        errorMessage = 'Judul dan isi progres tidak boleh kosong.';
        isSubmitting = false;
      });
      return;
    }

    final result = await progresProvider.kirimProgress(
      judul: widget.judulProgress.text,
      isi: widget.isiProgress.text,
      images: _selectedImages,
      tags: _selectedTags,
      idLaporan: selectedLaporanIds,
      persenProgress: double.tryParse(_persenController.text) ?? 0.0,
      idProgressSebelumnya: idProgressSebelumnya,
    );

    if (result.success) {
      // Reset form setelah sukses
      widget.judulProgress.clear();
      widget.isiProgress.clear();
      _selectedImages.clear();
      _selectedTags.clear();
      selectedLaporanIds.clear();

      // Tampilkan dialog sukses
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          child: SystemMessageCardOke(
            message: 'Progress berhasil diupload.',
          ),
        ),
      );

      // debug semua data yang dikirim
      debugPrint('Judul: ${widget.judulProgress.text}');
      debugPrint('Isi: ${widget.isiProgress.text}');
      debugPrint('Selected Laporan IDs: $selectedLaporanIds');
    } else {
      setState(() {
        errorMessage = result.message;
      });
      // Tampilkan dialog error
      DialogHelper.showErrorDialog(
        // ignore: use_build_context_synchronously
        context: context,
        message: result.message,
        onClose: () => setState(() => errorMessage = null),
      );

      debugPrint('Error saat mengirim progres: ${result.message}');
      // debug semua data yang dikirim
      debugPrint('Judul: ${widget.judulProgress.text}');
      debugPrint('Isi: ${widget.isiProgress.text}');
      debugPrint('Selected Laporan IDs: $selectedLaporanIds');
    }

    setState(() => isSubmitting = false);
  }

  // Fungsi untuk mengonfirmasi penghapusan gambar
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

  // Fungsi untuk membuka dialog pemilihan gambar
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
  
  // Fungsi untuk menambahkan laporan baru ke progres
  void addLaporanToProgress() {
    setState(() {
      selectedLaporanIds.add(null); // Tambah 1 dropdown kosong
    });
  }

  // Fungsi Refresh data
  Future<void> _refresh() async {
    try {
      // Ambil provider
      final laporanProvider = Provider.of<LaporanProvider>(context, listen: false);
      final progressProvider = Provider.of<ProgressProvider>(context, listen: false);

      // Panggil fungsi fetch dari masing-masing provider
      await Future.wait([
        laporanProvider.fetchLaporanDiterima(),
        progressProvider.fetchProgress(),
      ]);
    } catch (e) {
      debugPrint('Gagal me-refresh data: $e');
    }
  }

 @override
  Widget build(BuildContext context) {
    final laporanProvider = Provider.of<LaporanProvider>(context);
    final progressList = context.watch<ProgressProvider>().progressList;
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text('List Laporan Terkait', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        
        const SizedBox(height: 10),

        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                ...List.generate(selectedLaporanIds.length, (index) {
                  // Filter laporan yang belum memiliki fk_id_progress
                  final filterLaporan = laporanList.where((laporan) => laporan.fkIdProgress == null ||
                  laporan.fkIdProgress == 0
                  ).toList();
                  final laporanBelumDipilih = filterLaporan.where((laporan) =>
                    !selectedLaporanIds.contains(laporan.id) ||
                    selectedLaporanIds[index] == laporan.id).toList();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: selectedLaporanIds[index],
                            items: laporanBelumDipilih.map((laporan) {
                              return DropdownMenuItem(
                                value: laporan.id,
                                child: Text(laporan.judul),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedLaporanIds[index] = value;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Pilih Laporan Diterima',
                              border: UnderlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // ignore: prefer_is_empty
                        if (selectedLaporanIds.length >= 1 )
                          IconButton(
                            onPressed: () {
                              setState(() {
                                selectedLaporanIds.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.close, color: Colors.red),
                            tooltip: 'Hapus pilihan ini',
                          ),
                      ],
                    ),
                  );
                }),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedLaporanIds.add(null);
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.black
                            ),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.add, color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Tambah laporan Diterima',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Input Progres sebelumnya
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text('List Progres Terkait', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),

        const SizedBox(height: 10),

        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                // Generate dropdown untuk memilih progres terkait
                // Dropdown untuk memilih progres sebelumnya
                DropdownButtonFormField<int>(
                  value: idProgressSebelumnya, // Ganti dengan ID progres sebelumnya jika ada
                  items: progressList.map((progress) {
                    return DropdownMenuItem(
                      value: progress.id,
                      child: Text(progress.judul),
                    );
                  }).toList(),
                  onChanged: (value) {
                    // Handle perubahan progres sebelumnya jika diperlukan
                    setState(() {
                      idProgressSebelumnya = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Pilih Progres Sebelumnya (opsional)',
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
                    controller: widget.judulProgress,
                    decoration: const InputDecoration(
                      labelText: 'Judul Progres',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                
                const SizedBox(height: 16),

                TextField(
                    controller: widget.isiProgress,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'Isi Progres',
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
          child: Text('Persentase Progres', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),

        const SizedBox(height: 10),

        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 32, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: double.tryParse(_persenController.text) ?? 0,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: '${_persenController.text}%',
                        onChanged: (value) {
                          setState(() {
                            _persenController.text = value.toStringAsFixed(0);
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: _persenController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onChanged: (val) {
                          final parsed = double.tryParse(val);
                          if (parsed != null && parsed >= 0 && parsed <= 100) {
                            setState(() {}); // supaya Slider ikut update
                          }
                        },
                        decoration: const InputDecoration(
                          isDense: true,
                          suffixText: '%',
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
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

        // Tombol untuk memilih gambar
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
                        child: const Icon(Icons.close, color: Colors.white, size: 8),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        
        const SizedBox(height: 16),

        // Tombol untuk mengirim progres
        Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: ElevatedButton.icon(
            onPressed: isSubmitting ? null : submitProgress,
            icon: isSubmitting
                ? const SizedBox(
                    height: 8,
                    width: 8,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.send),
            label: const Text(
              'Publish Progress',
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