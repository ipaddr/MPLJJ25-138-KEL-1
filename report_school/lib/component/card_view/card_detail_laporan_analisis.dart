import 'package:flutter/material.dart';

class CardDetailLaporanAnalisis extends StatelessWidget {
  const CardDetailLaporanAnalisis({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Informasi Pengirim
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
                    children: const [
                      Text(
                        'Nama Pengirim',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color(0xFFFF9149),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text('John'),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Rating Pengguna',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color(0xFFFF9149),
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star, 
                            color: Colors.orange,
                            size: 18,
                          ),
                          Icon(
                            Icons.star, 
                            color: Colors.orange,
                            size: 18,
                          ),
                          Icon(
                            Icons.star, 
                            color: Colors.orange,
                            size: 18,
                          ),
                          Icon(
                            Icons.star, 
                            color: Colors.orange,
                            size: 18,
                          ),
                          Icon(
                            Icons.star, 
                            color: Colors.orange,
                            size: 18,
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
          
          // Informasi Laporan
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Judul Laporan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF9149),
                        ),
                      ),
                      Text(
                        'Nama Sekolah',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF9149),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Laporan 1'),
                      Text('Sekolah A'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Lokasi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF9149),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Jln. contoh, rt 11, air tawar\nKabupaten Kota'),
                  const SizedBox(height: 12),
                  const Text(
                    'Tanggal Laporan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF9149),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Kamis 14 Oktober 2024'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Tingkat Kerusakan/Kekurangan
          const Text(
            'Tingkat Kerusakan/Kekurangan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Card(
            color: Color(0xFFC50000),
            child: Padding(
              padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Dasar Barang Rusak',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '- Kursi (Rusak Ringan)\n'
                                '- Meja (Rusak Sedang)\n'
                                '- Papan Tulis (Rusak Berat)',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: Color(0xFFC0B000),
            child: Padding(
              padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Dasar Barang Kekurangan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '- Kursi (10 Unit)\n'
                                '- Meja (1 Unit)\n'
                                '- Papan Tulis (3 Unit)',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
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
