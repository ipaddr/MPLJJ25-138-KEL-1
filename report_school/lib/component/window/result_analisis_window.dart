import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:report_school/component/card_view/analisis_laporan/card_persenan_rusak.dart';
import 'package:report_school/component/card_view/analisis_laporan/card_laporan_analisis_window.dart';
import 'package:report_school/providers/get_laporan_detail_provider.dart';

class ResultAnalisisWindow extends StatefulWidget {
  final Map<String, dynamic> data;
  final int? laporanId;

  const ResultAnalisisWindow({
    super.key,
    required this.data,
    this.laporanId ,
  });

  @override
  State<ResultAnalisisWindow> createState() => _ResultAnalisisWindowState();
}

class _ResultAnalisisWindowState extends State<ResultAnalisisWindow> {
  @override
  void initState() {
    super.initState();
    // Fetch laporan detail berdasarkan ID saat pertama build
    final provider = Provider.of<GetDetailLaporanProvider>(context, listen: false);
    if (widget.laporanId != null) {
      provider.fetchLaporanDetail(widget.laporanId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GetDetailLaporanProvider>(context);
    final laporan = provider.laporan;

    double rusakBerat = widget.data["rusak_berat"] ?? 0.0;
    double rusakSedang = widget.data["rusak_sedang"] ?? 0.0;
    double rusakRingan = widget.data["rusak_ringan"] ?? 0.0;

    return SizedBox(
      width: 350,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (provider.loading)
                  const Center(child: CircularProgressIndicator())
                else if (provider.error != null)
                  Text(provider.error!, style: const TextStyle(color: Colors.red))
                else if (laporan != null)
                  CardLaporanAnalisis(laporan: laporan)
                else
                  const Text("Laporan tidak ditemukan", style: TextStyle(color: Colors.red)),

                const SizedBox(height: 16),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Persenan tingkat kerusakan",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),

                const SizedBox(height: 8),

                CardPersenanRusak(
                  rusakBerat: rusakBerat,
                  rusakSedang: rusakSedang,
                  rusakRingan: rusakRingan,
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
