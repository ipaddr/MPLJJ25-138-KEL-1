import 'package:flutter/material.dart';
import '../component/form/form_laporan.dart';
import '../controller/sekolah_controller.dart';
import 'package:provider/provider.dart';


class FormLaporanPage extends StatefulWidget {
  const FormLaporanPage({super.key});

  @override
  State createState() => _ListLaporanPageState();
}

class _ListLaporanPageState extends State<FormLaporanPage> {

  @override
  Widget build(BuildContext context) {
    final sekolahCtrl = Provider.of<SekolahController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Form Laporan')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            const SizedBox(height: 4),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                LaporanFormCard(
                  judulController: sekolahCtrl.judulController,
                  isiController: sekolahCtrl.isiController,
                  selectedSekolah: sekolahCtrl.selectedSekolah,
                  daftarSekolah: sekolahCtrl.daftarSekolah,
                  onSekolahChanged: sekolahCtrl.updateSelectedSekolah,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}