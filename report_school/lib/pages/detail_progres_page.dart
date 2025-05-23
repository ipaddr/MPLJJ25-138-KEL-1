import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../component/card_view/card_progres_detail.dart';
import '../component/card_view/card_file_pendukung.dart';
import '../providers/home_provider.dart';

class DetailProgresPage extends StatelessWidget {
  const DetailProgresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Progres'),
        centerTitle: true,
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardProgresDetail(
                    laporanList: provider.laporanList,
                    judulProgres: "Pembangunan Jalan Akses Desa",
                    deskripsiProgres: "Proyek ini bertujuan untuk meningkatkan infrastruktur transportasi...",
                    persenProgress: 0.65,
                  ),
                  const CardFilePendukung(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
