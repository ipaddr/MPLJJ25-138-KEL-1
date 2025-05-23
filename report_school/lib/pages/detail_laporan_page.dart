import 'package:flutter/material.dart';
import '../component/card_view/card_laporan_detail.dart';
import '../component/card_view/card_file_pendukung.dart';

class DetailLaporanPage extends StatelessWidget {
  const DetailLaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Laporan'),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Pakai scroll agar tidak overflow
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... komponen lainnya misalnya judul, deskripsi, dsb.

              const CardDetailLaporan(),
              // === Tambahkan CardFilePendukung di sini ===
              const CardFilePendukung(),
            ],
          ),
        ),
      ),
    );
  }
}
