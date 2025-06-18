import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/form_laporan_page.dart';
import '../theme/app_theme.dart';
import '../providers/home_provider.dart';
import '../providers/pengumuman_provider.dart';
import '../component/card_view/card_laporan_home.dart';
import '../component/card_view/card_pengumuman.dart';
import '../pages/form_progres_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    // Fetch laporan dan pengumuman saat pertama kali dibuka
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      final laporanProvider = Provider.of<HomeProvider>(context, listen: false);
      // ignore: use_build_context_synchronously
      final pengumumanProvider = Provider.of<PengumumanProvider>(context, listen: false);
      // ignore: use_build_context_synchronously
      final checkAdmin = Provider.of<HomeProvider>(context, listen: false);

      laporanProvider.fetchLaporanHariIni();
      checkAdmin.checkIsAdmin();
      pengumumanProvider.addDummyPengumuman();
    });
  }

  Future<void> _refreshData() async {
    await context.read<HomeProvider>().fetchLaporanHariIni();
    // ignore: use_build_context_synchronously
    await context.read<HomeProvider>().checkIsAdmin();
  }

  @override
  Widget build(BuildContext context) {
    final laporanListHariIni = context.watch<HomeProvider>().laporanHariIniList;
    final pengumumanList = context.watch<PengumumanProvider>().pengumumanList;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Beranda')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: RefreshIndicator(
              onRefresh: _refreshData,
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
                 Consumer<HomeProvider>(
                    builder: (context, provider, _) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: laporanListHariIni.length,
                        itemBuilder: (context, index) {
                          return CardLaporanHome(laporan: laporanListHariIni[index]);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Fitur User
          if (!context.watch<HomeProvider>().isAdmin) ...[
            // --- FAB Tambah Laporan ---
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                heroTag: "fabTambah",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FormLaporanPage()),
                  ).then((_) {
                    // ignore: use_build_context_synchronously
                    context.read<HomeProvider>().fetchLaporanHariIni();
                  });
                },
                backgroundColor: AppTheme.greenCard_185,
                tooltip: "Tambah Laporan",
                child: Icon(Icons.add, color: AppTheme.white),
              ),
            ),
          ],

          // Fitur Admin
          if (context.watch<HomeProvider>().isAdmin) ...[
              // --- FAB Analisis ---
              Positioned(
                bottom: 16,
                right: 86,
                child: FloatingActionButton(
                  heroTag: "fabAnalisis",
                  onPressed: () {
                    /*
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ListLaporanPageAnalisis()),
                    ).then((_) {
                      context.read<HomeProvider>().fetchLaporanHariIni();
                    });
                    */
                },
                backgroundColor: AppTheme.orangeCard_185,
                tooltip: "Analisis Laporan",
                child: Icon(Icons.analytics, color: AppTheme.white),
              ),
            ),
          ],

          // Fitur Admin
          if (context.watch<HomeProvider>().isAdmin) ...[
            // --- FAB Progres ---
            Positioned(
              bottom: 16, // + 70 jika mau di atas FAB Tambah
              right: 16,
              child: FloatingActionButton(
                heroTag: "fabTambahProgres",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FormProgresPage()),
                  ).then((_) {
                    // ignore: use_build_context_synchronously
                    context.read<HomeProvider>().fetchLaporanHariIni();
                  });
                },
                backgroundColor: AppTheme.greenCard_185,
                tooltip: "Tambah Progres",
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Icon(Icons.insert_chart_outlined, size: 32, color: AppTheme.white),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.teal,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(Icons.add, size: 12, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
