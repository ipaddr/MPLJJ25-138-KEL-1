import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/home_provider.dart';
import '../providers/pengumuman_provider.dart'; // Import PengumumanProvider
import '../component/card_view/card_laporan_home.dart';
import '../component/card_view/card_pengumuman.dart'; // Import CardPengumuman
import '../pages/form_laporan_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<HomeProvider>(context, listen: false);
    provider.addDummyData(); // sekali saja isi data

    final pengumumanProvider = Provider.of<PengumumanProvider>(
      context,
      listen: false,
    );
    pengumumanProvider
        .addDummyPengumuman(); // Menambahkan data dummy pengumuman
  }

  @override
  Widget build(BuildContext context) {
    final laporanList = context.watch<HomeProvider>().laporanList;
    final pengumumanList =
        context
            .watch<PengumumanProvider>()
            .pengumumanList; // Assuming you have pengumuman in provider

    return Scaffold(
      appBar: AppBar(title: const Text('Beranda')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: ListView(
          children: [
            // Pengumuman Section
            Text(
              'Pengumuman', // Judul Pengumuman
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color:
                    Theme.of(context)
                        .colorScheme
                        .onSurface, // Menggunakan warna primer dari tema
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 1, // Ketebalan garis bawah
              color: Theme.of(context).colorScheme.onSurface,
              margin: const EdgeInsets.symmetric(vertical: 8),
            ),

            // Card Pengumuman
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pengumumanList.length,
              itemBuilder: (context, index) {
                return CardPengumuman(pengumuman: pengumumanList[index]);
              },
            ),

            const SizedBox(height: 30),

            // Laporan Terbaru Section
            Text(
              'Laporan Terbaru', // Judul Laporan Terbaru
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color:
                    Theme.of(context)
                        .colorScheme
                        .onSurface, // Menggunakan warna primer dari tema
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 1, // Ketebalan garis bawah
              color: Theme.of(context).colorScheme.onSurface,
              margin: const EdgeInsets.symmetric(vertical: 8),
            ),

            // Daftar Laporan
            Expanded(
              child: ListView.builder(
                shrinkWrap:
                    true, // Menghindari masalah dengan penggunaan Expanded di dalam ListView
                itemCount: laporanList.length,
                itemBuilder: (context, index) {
                  return CardLaporan(laporan: laporanList[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aksi ketika tombol ditekan
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormLaporanPage()),
          );
        },
        backgroundColor: AppTheme.greenCard_185, // Warna background tombol
        tooltip: "Tambah Laporan",
        child: Icon(
          Icons.add,
          color: AppTheme.white, // Warna ikon
        ),
      ),
    );
  }
}
