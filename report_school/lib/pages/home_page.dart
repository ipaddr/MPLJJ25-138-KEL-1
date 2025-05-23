import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/form_laporan_page.dart';
import '../theme/app_theme.dart';
import '../providers/home_provider.dart';
import '../providers/pengumuman_provider.dart'; // Import PengumumanProvider
import '../component/card_view/card_laporan_home.dart';
import '../component/card_view/card_pengumuman.dart'; // Import CardPengumuman
import '../pages/admin/analisis_laporan_page.dart';

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

    final pengumumanProvider = Provider.of<PengumumanProvider>(context, listen: false);
    pengumumanProvider.addDummyPengumuman();  // Menambahkan data dummy pengumuman
  }

  @override
Widget build(BuildContext context) {
  final laporanList = context.watch<HomeProvider>().laporanList;
  final pengumumanList = context.watch<PengumumanProvider>().pengumumanList;

  return Scaffold(
    backgroundColor: Colors.transparent,
    appBar: AppBar(title: const Text('Beranda')),
    body: Stack(

      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: ListView(
            children: [
              // --- Pengumuman Section ---
              Text(
                'Pengumuman',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 1,
                color: Theme.of(context).colorScheme.onSurface,
                margin: const EdgeInsets.symmetric(vertical: 8),
              ),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pengumumanList.length,
                itemBuilder: (context, index) {
                  return CardPengumuman(pengumuman: pengumumanList[index]);
                },
              ),

              const SizedBox(height: 30),

              // --- Laporan Terbaru Section ---
              Text(
                'Laporan Terbaru',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 1,
                color: Theme.of(context).colorScheme.onSurface,
                margin: const EdgeInsets.symmetric(vertical: 8),
              ),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: laporanList.length,
                itemBuilder: (context, index) {
                  return CardLaporan(laporan: laporanList[index]);
                },
              ),
            ],
          ),
        ),

        // --- Floating Buttons ---
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            heroTag: "fabTambah",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const FormLaporanPage(),
              ));
            },
            backgroundColor: AppTheme.greenCard_185,
            tooltip: "Tambah Laporan",
            child: Icon(Icons.add, color: AppTheme.white),
          ),
        ),
        // Button untuk analisis laporan
        Positioned(
          bottom: 16,
          right: 86,
          child: FloatingActionButton(
            heroTag: "fabAnalisis",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const ListLaporanPageAnalisis(),
              ));
            },
            backgroundColor: AppTheme.orangeCard_185,
            tooltip: "Analisis Laporan",
            child: Icon(Icons.analytics, color: AppTheme.white),
          ),
        ),
        // Button untuk tambah Progres
        Positioned(
          bottom: 16 + 70,
          right: 16,
          child: FloatingActionButton(
            heroTag: "fabTambahProgres",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const ListLaporanPageAnalisis(),
              ));
            },
            backgroundColor: AppTheme.greenCard_185,
            tooltip: "Tambah Progres",
           child:
            Stack(
              alignment: Alignment.topRight,
              children: [
                Icon(Icons.insert_chart_outlined, size: 32, color: AppTheme.white),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: const Icon(Icons.add, size: 12, color: Colors.white),
                  ),
                ),
              ],
            )
          ),
        ),
      ],
    ),
  );
}

}
