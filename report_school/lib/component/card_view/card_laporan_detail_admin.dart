import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:report_school/providers/laporan_provider.dart';
import 'package:report_school/theme/app_theme.dart';
import '../../models/laporan.dart';
import '../window/konfirmasi_window.dart';

class CardDetailLaporanAdmin extends StatelessWidget {
  final Laporan laporan;

  const CardDetailLaporanAdmin({super.key, required this.laporan});

  @override
  Widget build(BuildContext context) {
    final tanggalFormatted =
        DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(laporan.tanggal);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Informasi Pengirim',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nama Pengirim
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nama Pengirim',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF9149),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(laporan.namaPengirim),
                    ],
                  ),
                  // Rating Pengguna
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Rating Pengguna',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF9149),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Row(
                            children: List.generate(5, (i) {
                              return Icon(
                                i < (laporan.user.rating ?? 0).round()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.orange,
                                size: 20,
                              );
                            }),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(${(laporan.user.rating ?? 0).toStringAsFixed(1)})',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF9149),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Text(
            'Informasi Laporan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul dan Sekolah
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Judul Laporan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF9149),
                        ),
                      ),
                      const Text(
                        'Nama Sekolah',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF9149),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(laporan.judul),
                      Text(laporan.namaSekolah),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tanggal Laporan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF9149),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(tanggalFormatted),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Isi Laporan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF9149),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(laporan.isi),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Status Laporan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF9149),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: laporan.status == 'diterima'
                            ? Colors.green
                            : laporan.status == 'ditolak'
                                ? Colors.red
                                : Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        laporan.status ?? 'Belum diverifikasi',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Tombol Aksi Tolak dan Terima
          if (laporan.status == 'Belum diverifikasi') ...[
            
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tombol Tolak
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.redCard,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                 onPressed: () async {
                    final konfirmasi = await showDialog<bool>(
                      context: context,
                      builder: (context) => const Dialog(
                        backgroundColor: Colors.transparent,
                        child: SystemMessageCard(
                          message: 'Apakah kamu yakin ingin menolak laporan ini?\nTindakan ini tidak dapat dibatalkan.',
                          yesText: 'Ya, Tolak',
                          noText: 'Batalkan',
                        ),
                      ),
                    );
                    if (konfirmasi == true) {
                      // Jika pengguna mengonfirmasi penolakan, set status laporan ke 'Ditolak'
                      // ignore: use_build_context_synchronously
                      context.read<LaporanProvider>().setLaporanStatus(context, laporan.id, 'ditolak');
                    }
                },
                child: const Text(
                  'Tolak Laporan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              // Tombol Terima
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.greenCard,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  final konfirmasi = await showDialog<bool>(
                    context: context,
                    builder: (context) => const Dialog(
                      backgroundColor: Colors.transparent,
                      child: SystemMessageCard(
                        message: 'Apakah kamu yakin ingin menerima laporan ini?\nTindakan ini tidak dapat dibatalkan.',
                        yesText: 'Ya, Terima',
                        noText: 'Batalkan',
                      ),
                    ),
                  );
                  if (konfirmasi == true) {
                    // Jika pengguna mengonfirmasi penerimaan, set status laporan ke 'Diterima'
                    // ignore: use_build_context_synchronously
                    context.read<LaporanProvider>().setLaporanStatus(context, laporan.id, 'diterima');
                  }
                },
                child: const Text(
                  'Terima Laporan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          ],
        ],
      ),
    );
  }
}
