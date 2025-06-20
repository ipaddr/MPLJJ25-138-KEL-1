import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/laporan.dart';
import '../../theme/app_theme.dart';
import '../../pages/detail_laporan_page.dart';
import '../elements/star_count.dart';
import '../window/berikan_rating_laporan_window.dart';

class CardLaporanHome extends StatelessWidget {
  final Laporan laporan;

  const CardLaporanHome({super.key, required this.laporan});

  @override
  Widget build(BuildContext context) {
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

            // Baris 1: Judul & Tanggal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    laporan.judul,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailLaporanPage(laporanId: laporan.id),
                      ),
                    );
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
                SizedBox(
                  width: 150,
                  height: 50,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          StarCount(rating: (laporan.rating).toDouble()),
                          Text(
                            '(4 user)', // Display rating with one decimal place
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFFF9149),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 4),
                      Text(
                          '(${((laporan.rating).toDouble()).toStringAsFixed(1)})', // Display rating with one decimal place
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF9149),
                          ),
                        ),
                    ],
                  ),

                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.redCard,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        backgroundColor: Colors.transparent,
                        child: BerikanRatingLaporanWindow(laporan: laporan),
                      ),
                    );
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
