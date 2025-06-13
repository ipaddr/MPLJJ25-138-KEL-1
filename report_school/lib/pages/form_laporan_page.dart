import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../component/form/form_laporan.dart';
import '../controller/sekolah_controller.dart';

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
      final sekolahCtrl = Provider.of<SekolahController>(context, listen: false);
      await sekolahCtrl.fetchSekolah();
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final sekolahCtrl = Provider.of<SekolahController>(context);

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
                    judulController: sekolahCtrl.judulController,
                    isiController: sekolahCtrl.isiController,
                    selectedSekolah: sekolahCtrl.selectedNamaSekolah,
                    daftarSekolah: sekolahCtrl.daftarNamaSekolah,
                    onSekolahChanged: sekolahCtrl.updateSelectedSekolah,
                  ),
                ],
              ),
      ),
    );
  }
}
