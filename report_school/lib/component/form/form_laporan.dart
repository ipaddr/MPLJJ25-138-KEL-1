import 'package:flutter/material.dart';

class LaporanFormCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informasi Umum',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 10),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4, // Tambahkan bayangan di sini
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                TextField(
                  controller: judulController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Laporan',
                    hintText: 'contoh nama laporan...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedSekolah,
                  items:
                      daftarSekolah.map((sekolah) {
                        return DropdownMenuItem(
                          value: sekolah,
                          child: Text(sekolah),
                        );
                      }).toList(),
                  onChanged: onSekolahChanged,
                  decoration: const InputDecoration(
                    labelText: 'Pilih Sekolah Tersedia',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4, // Tambahkan bayangan di sini juga
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: TextField(
              controller: isiController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Isi Laporan',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
