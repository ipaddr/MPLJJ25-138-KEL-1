import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/laporan_provider.dart';
import '../../component/card_view/card_laporan_analisis.dart';

class ListLaporanPageAnalisis extends StatefulWidget {
  const ListLaporanPageAnalisis({super.key});

  @override
  State<ListLaporanPageAnalisis> createState() => _ListLaporanPageAnalisisState();
}

class _ListLaporanPageAnalisisState extends State<ListLaporanPageAnalisis> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      Provider.of<LaporanProvider>(context, listen: false).fetchLaporan(); // fetch semua laporan
    });
  }

  @override
  Widget build(BuildContext context) {
    final laporanList = context.watch<LaporanProvider>().laporanListAll;

    final filteredLaporanList = laporanList.where((laporan) {
      return laporan.judul.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('List Laporan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari laporan',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),
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
