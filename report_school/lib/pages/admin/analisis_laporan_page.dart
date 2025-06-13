/*
import 'package:flutter/material.dart';
import '../../models/laporan.dart';
import '../../component/card_view/card_laporan_analisis.dart'; // ganti path sesuai strukturmu

class ListLaporanPageAnalisis extends StatefulWidget {
  const ListLaporanPageAnalisis({super.key});

  @override
  State<ListLaporanPageAnalisis> createState() => _ListLaporanPageAnalisisState();
}

class _ListLaporanPageAnalisisState extends State<ListLaporanPageAnalisis> {
  final List<Laporan> laporanList = [
    Laporan(
      idLaporan: 1,
      judul: 'Laporan Kerusakan 1',
      namaPengirim: 'Andi',
      tanggal: DateTime(2025, 3, 23),
      rating: 4.0,
    ),
    Laporan(
      idLaporan: 2,
      judul: 'Meja Tidak Cukup',
      namaPengirim: 'Budi',
      tanggal: DateTime(2025, 3, 24),
      rating: 3.5,
    ),
    Laporan(
      judul: 'Kursi Patah',
      namaPengirim: 'Citra',
      tanggal: DateTime(2025, 3, 25),
      rating: 5.0,
    ),
  ];

  List<Laporan> filteredLaporanList = [];

  @override
  void initState() {
    super.initState();
    filteredLaporanList = laporanList;
  }

  void _filterLaporan(String query) {
    final filtered = laporanList.where((laporan) {
      final judulLower = laporan.judul.toLowerCase();
      final queryLower = query.toLowerCase();
      return judulLower.contains(queryLower);
    }).toList();

    setState(() {
      filteredLaporanList = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Laporan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari laporan',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: _filterLaporan,
            ),
            const SizedBox(height: 16),

            // List laporan hasil filter
            Expanded(
              child: filteredLaporanList.isEmpty
                  ? const Center(child: Text('Laporan tidak ditemukan'))
                  : ListView.separated(
                      itemCount: filteredLaporanList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return CardLaporanAnalisis(laporan: filteredLaporanList[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
*/