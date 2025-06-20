import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:report_school/component/window/result_analisis_window.dart';
import 'package:report_school/models/laporan.dart';
import 'package:report_school/pages/detail_laporan_page.dart';
import 'package:report_school/providers/laporan_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
            // Judul dan Tanggal
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
                const SizedBox(width: 16),
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

            // Pengirim dan tombol detail
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
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
              ],
            ),
            const SizedBox(height: 8),

            // Rating dan tombol analisis
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IgnorePointer(
                  child: RatingBar.builder(
                    initialRating: laporan.rating.toDouble(),
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
                    onRatingUpdate: (_) {},
                  ),
                ),
                SizedBox(
                  width: 130,
                  child: ElevatedButton(
                    onPressed: () async {
                      final provider = Provider.of<LaporanProvider>(context, listen: false);

                      if (laporan.fotoUrls.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Tidak ada foto untuk dianalisis")),
                        );
                        return;
                      }

                      // Tampilkan dialog loading
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Dialog(
                          backgroundColor: Colors.transparent,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      );

                      final hasil = await provider.analisisSemuaGambarLaporan(laporan.fotoUrls);

                      // Tutup dialog loading
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();

                      if (hasil != null) {
                        showDialog(

                          // ignore: use_build_context_synchronously
                          context: context,
                          builder: (context) => Dialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: ResultAnalisisWindow(
                              laporanId: laporan.id,
                              data: hasil,
                            ),
                          ),
                        );
                      } else {
                        showDialog(
                          // ignore: use_build_context_synchronously
                          context: context,
                          builder: (context) => const Dialog(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text("Gagal menganalisis laporan."),
                            ),
                          ),
                        );
                      }
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
