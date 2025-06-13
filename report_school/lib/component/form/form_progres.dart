import 'package:flutter/material.dart';

class LaporanProgresCard extends StatelessWidget {
  final TextEditingController judulController;
  final TextEditingController isiController;
  final String? selectedSekolah;
  final List<String> daftarSekolah;
  final Function(String?) onSekolahChanged;

  const LaporanProgresCard({
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Bagian untuk memilih laporan diterima
        const Text(
          'Tambah Progres',
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
                // Dropdown untuk memilih laporan diterima
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
                    labelText: 'Pilih laporan diterima',
                    border: OutlineInputBorder(),
                  ),
                ),

                // Button untuk menambah laporan diterima
                const SizedBox(height: 16),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4, // Tambahkan bayangan di sini juga
                  child: ElevatedButton(
                    onPressed: () {
                      // Aksi untuk menambah laporan diterima
                    },
                    child: const Text('Tambah Laporan Diterima'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Bagian untuk informasi progres laporan
        const Text(
          'Informasi Progres Laporan',
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
                    labelText: 'Judul Progres Laporan',
                    hintText: 'contoh nama progres...',
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
                labelText: 'Isi Progres Laporan',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Bagian untuk file pendukung
        const Text(
          'File Pendukung',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ],
    );
  }
}
