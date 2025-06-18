import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../component/card_view/card_laporan_detail.dart';
import '../component/card_view/card_file_pendukung.dart';
import '../providers/get_detail_laporan_provider.dart';

class DetailLaporanPage extends StatefulWidget {
  final int laporanId;

  const DetailLaporanPage({super.key, required this.laporanId});

  @override
  State<DetailLaporanPage> createState() => _DetailLaporanPageState();
}

class _DetailLaporanPageState extends State<DetailLaporanPage> {
  @override
  void initState() {
    super.initState();
    // Ambil detail laporan saat halaman dibuka
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      final provider = Provider.of<GetDetailLaporanProvider>(context, listen: false);
      provider.fetchLaporanDetail(widget.laporanId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Laporan'),
        centerTitle: true,
      ),
      body: Consumer<GetDetailLaporanProvider>(
        builder: (context, provider, child) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          final laporan = provider.laporan;
          if (laporan == null) {
            return const Center(child: Text('Laporan tidak ditemukan.'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CardDetailLaporan(laporan: laporan),
                CardFilePendukung(
                  fotoPaths: laporan.fotoUrls,
                  tags: laporan.tags,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
