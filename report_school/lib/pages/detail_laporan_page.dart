import 'package:flutter/material.dart';
import '../component/card_view/card_laporan_detail.dart';

class DetailLaporanPage extends StatelessWidget {
  const DetailLaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Laporan'),
      ),
      body: const CardDetailLaporan(),
    );
  }
}
