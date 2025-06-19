import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../component/form/form_laporan.dart';
import '../controller/laporan_controller.dart';

class FormLaporanPage extends StatefulWidget {
  const FormLaporanPage({super.key});

  @override
  State<FormLaporanPage> createState() => _FormLaporanPageState();
}

class _FormLaporanPageState extends State<FormLaporanPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Ambil data sekolah saat pertama kali halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final laporanCtrl = Provider.of<LaporanController>(context, listen: false);
      await laporanCtrl.fetchSekolah();
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final laporanCtrl = Provider.of<LaporanController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Form Laporan')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  const SizedBox(height: 8),
                  LaporanFormCard(
                    judulLaporan: laporanCtrl.judulLaporan,
                    isiLaporan: laporanCtrl.isiLaporan,
                    selectedSekolah: laporanCtrl.selectedNamaSekolah,
                    daftarSekolah: laporanCtrl.daftarNamaSekolah,
                    onSekolahChanged: laporanCtrl.updateSelectedSekolah,
                  ),
                ],
              ),
      ),
    );
  }
}
