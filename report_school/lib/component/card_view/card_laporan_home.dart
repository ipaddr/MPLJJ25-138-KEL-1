import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/laporan.dart';
import 'package:provider/provider.dart';
import '../../providers/home_provider.dart';
import '../../theme/app_theme.dart';

class CardLaporan extends StatelessWidget {
  final Laporan laporan;

  const CardLaporan({super.key, required this.laporan});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    final tanggalFormatted = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(laporan.tanggal);

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
            // color card

            // Baris 1: Judul & Tanggal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    laporan.judul,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  tanggalFormatted,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.textColorBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Baris 2: Nama pengirim & tombol detail
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  laporan.namaPengirim,
                  style: const TextStyle(fontSize: 14),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.blueCard,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Navigasi ke halaman detail
                  },
                  child: const Text(
                    'Detail Laporan',
                    style: TextStyle(color: AppTheme.textColorWhite),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),

            // Baris 3: Bintang & Tombol Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Bintang interaktif
                Row(
                  children: List.generate(5, (index) {
                    final starFilled = index < laporan.rating;
                      return IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(
                          starFilled ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 18,
                        ),
                        onPressed: () {
                          provider.updateRating(laporan, index + 1);
                        },
                      );
                    }).expand((widget) sync* {
                      yield widget;
                      yield const SizedBox(width: 4);
                    }).toList(),
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                     backgroundColor: AppTheme.redCard,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Munculkan dialog/halaman rating
                  },
                  child: const Text(
                      'Berikan Rating',
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
