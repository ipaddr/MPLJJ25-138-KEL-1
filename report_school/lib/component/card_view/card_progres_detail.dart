import 'package:flutter/material.dart';
import '../../models/laporan.dart';
import '../card_view/card_laporan_home.dart';

class CardProgresDetail extends StatelessWidget {
  final List<Laporan> laporanList;
  final String judulProgres;
  final String deskripsiProgres;
  final double persenProgress; // 0.0 - 1.0

  const CardProgresDetail({
    super.key,
    required this.laporanList,
    required this.judulProgres,
    required this.deskripsiProgres,
    required this.persenProgress,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daftar laporan/progress terkait',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Column(
            children: laporanList
                .map((laporan) => CardLaporan(laporan: laporan))
                .toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            'Informasi Umum',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: 
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Judul progres',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(judulProgres),
                                const SizedBox(height: 12),
                                const Text(
                                  'Deskripsi progres',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(deskripsiProgres),
                            ],
                          ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: const Color(0xFF6C8BFF),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Progres pembangunan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      minHeight: 8,
                      value: persenProgress,
                      backgroundColor: Colors.white,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
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
