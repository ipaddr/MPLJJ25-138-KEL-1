import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Jangan lupa import intl untuk format tanggal
import '../../models/pengumuman.dart'; // Pastikan ini path yang benar ke file model Pengumuman
import '../../theme/app_theme.dart'; // Pastikan ini path yang benar ke file tema

class CardPengumuman extends StatelessWidget {
  final Pengumuman pengumuman;

  const CardPengumuman({super.key, required this.pengumuman});

  @override
  Widget build(BuildContext context) {
    final tanggalFormatted = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(pengumuman.tanggal);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris 1: Judul Pengumuman
            Text(
              pengumuman.judul,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            // Baris 2: Deskripsi
            Text(
              pengumuman.deskripsi,
              style: const TextStyle(fontSize: 11,color: AppTheme.textColorBlack)
            ),
            const SizedBox(height: 8),

            // Baris 3: Tanggal Pengumuman
            Text(
              tanggalFormatted,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.textColorBlack,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            // Baris 4: Foto
            if (pengumuman.foto.url.isNotEmpty) 
              SizedBox(
                width: 150,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    pengumuman.foto.url,
                    fit: BoxFit.contain, // Tidak memotong gambar
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
            ),
          ],
        ),
      ),
    );
  }
}
