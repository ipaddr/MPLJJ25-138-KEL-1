import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../component/form/form_progres.dart';
import '../controller/progress_controller.dart';


class FormProgresPage extends StatefulWidget {
  const FormProgresPage({super.key});

  @override
  State createState() => _ListLaporanPageState();
}

class _ListLaporanPageState extends State<FormProgresPage> {

  @override
  Widget build(BuildContext context) {
    final progressCtrl = Provider.of<ProgressController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Form Progres')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            const SizedBox(height: 4),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                LaporanProgresCard(
                  judulProgress: progressCtrl.judulProgress,
                  isiProgress: progressCtrl.isiProgress,
                  selectedLaporan: progressCtrl.selectedLaporan?.judul,
                  daftarLaporan: progressCtrl.daftarJudulLaporan,
                  onLaporanChanged: progressCtrl.updateSelectedLaporanByJudul,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}