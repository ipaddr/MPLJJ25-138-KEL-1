import 'package:flutter/material.dart';

class CardDetailLaporan extends StatelessWidget {
  const CardDetailLaporan({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                  children: const [
                    Text(
                      'Nama Pengirim',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
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
                        color: Color(0xFFFF9149),
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange),
                        Icon(Icons.star, color: Colors.orange),
                        Icon(Icons.star, color: Colors.orange),
                        Icon(Icons.star, color: Colors.orange),
                        Icon(Icons.star_border, color: Colors.orange),
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
                const SizedBox(height: 12),
                
              ],
            ),
          ),
        ),

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
                  const Text(
                    'ini adalah contoh isi laporan ,\n'
                    'ini adalah contoh isi laporan ,\n'
                    'ini adalah contoh isi laporan ,\n'
                    'ini adalah contoh isi laporan ,\n'
                    'ini adalah contoh isi laporan ,',
                  ),
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
                Column(
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
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Ditolak',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
