import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:report_school/component/window/result_analisis_window.dart';
import '../../models/laporan.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../pages/detail_laporan_page.dart';

class CardLaporanAnalisis extends StatelessWidget {
  final Laporan laporan;

  const CardLaporanAnalisis({super.key, required this.laporan});

  @override
  Widget build(BuildContext context) {
    final tanggalFormatted = DateFormat('EEEE dd-MM-yyyy', 'id_ID').format(laporan.tanggal);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Laporan (besar dan tebal)
            // Baris 1: Judul Laporan dan Tanggal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    laporan.judul,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16), // Jarak antara judul dan tanggal
                Text(
                  tanggalFormatted,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
           
            const SizedBox(height: 16),

            // Baris untuk Nama Pengirim dan Tombol Detail Laporan
            // Baris 2: nama pengirim dan detail laporan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Nama pengirim: ',
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    children: [
                      TextSpan(
                        text: laporan.namaPengirim,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    width: 130,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailLaporanPage(laporanId: laporan.id),
                              ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Detail Laporan",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Baris Bintang dan juga baris tombol analisis
            // Baris 3: Bintang dan Analisis
            Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 IgnorePointer(
                  child: RatingBar.builder(
                    initialRating: laporan.rating.toDouble(), // dari Provider nanti
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 20,
                    unratedColor: Colors.grey.shade400,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      // Tidak dipakai karena ignorePointer
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    width: 130,
                    child: ElevatedButton(
                      onPressed: () {
                        // Buka dialog analisis
                        _showAnalisisDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Analisis",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan dialog analisis
  void _showAnalisisDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ResultAnalisisWindow()
        );
          
      },
    );
  }
}