import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:report_school/component/card_view/card_laporan_detail_admin.dart';
import '../../component/card_view/card_file_pendukung.dart';
import '../../providers/get_laporan_detail_provider.dart';

class DetailLaporanPageAdmin extends StatefulWidget {
  final int laporanId;

  const DetailLaporanPageAdmin({super.key, required this.laporanId});

  @override
  State<DetailLaporanPageAdmin> createState() => _DetailLaporanPageAdminState();
}

class _DetailLaporanPageAdminState extends State<DetailLaporanPageAdmin> {
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
                CardDetailLaporanAdmin(laporan: laporan),
                CardFilePendukung(
                  idLaporan: laporan.id,
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
