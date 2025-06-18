import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/laporan.dart';

class CardDetailLaporan extends StatelessWidget {
  final Laporan laporan;

  const CardDetailLaporan({super.key, required this.laporan});

  @override
  Widget build(BuildContext context) {
    final tanggalFormatted =
        DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(laporan.tanggal);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                          const SizedBox(width: 8),
                          Text(
                            '(${(laporan.user.rating ?? 0).toStringAsFixed(1)})', // Display rating with one decimal place
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
              child: 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
              child: 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Column(
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
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: 
              Row(
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
                        color: Colors.red,
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
        ],
      ),
    );
  }
}
