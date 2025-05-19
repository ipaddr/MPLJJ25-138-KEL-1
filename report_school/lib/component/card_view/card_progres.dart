import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../models/progres.dart';
import '../../pages/detail_laporan_page.dart';

class CardProgress extends StatelessWidget {
  
  final Progres progres;

  const CardProgress({super.key, required this.progres});
  @override
  Widget build(BuildContext context) {
    final tanggalFormatted = DateFormat('dd-MM-yyyy').format(progres.tanggal);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris 1: Judul
            Text(
              progres.judul,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Baris 2: Nama pengirim
            Text(
              progres.namaPengirim,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),

            // Baris 3: Tanggal & tombol detail
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tanggalFormatted,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.textColorBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.blueCard,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const DetailLaporanPage(),
                    ));
                  },
                  child: const Text(
                    'Detail Progress',
                    style: TextStyle(color: AppTheme.textColorWhite),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}