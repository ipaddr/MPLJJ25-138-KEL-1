import 'package:flutter/material.dart';
import '../controller/sekolah_controller.dart';
import 'package:provider/provider.dart';
import '../component/form/form_progres.dart';


class FormProgresPage extends StatefulWidget {
  const FormProgresPage({super.key});

  @override
  State createState() => _ListLaporanPageState();
}

class _ListLaporanPageState extends State<FormProgresPage> {

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
                LaporanProgresCard(
                  judulController: sekolahCtrl.judulController,
                  isiController: sekolahCtrl.isiController,
                  selectedSekolah: sekolahCtrl.selectedNamaSekolah,
                  daftarSekolah: sekolahCtrl.daftarNamaSekolah,
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