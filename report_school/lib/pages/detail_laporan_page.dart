import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:report_school/component/card_view/card_laporan_detail_admin.dart';
import 'package:report_school/component/card_view/card_laporan_detail.dart';
import '../component/card_view/card_file_pendukung.dart';
import '../providers/get_laporan_detail_provider.dart';
import '../providers/auth_provider.dart';

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
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      final provider = Provider.of<GetDetailLaporanProvider>(context, listen: false);
      provider.fetchLaporanDetail(widget.laporanId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().isAdmin;

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
                isAdmin
                    ? CardDetailLaporanAdmin(laporan: laporan)
                    : CardDetailLaporan(laporan: laporan),
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
