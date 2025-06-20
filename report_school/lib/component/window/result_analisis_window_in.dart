import 'package:flutter/material.dart';
import '../card_view/analisis_laporan/card_persenan_rusak.dart';

class ResultAnalisisWindowIn extends StatelessWidget {
  final Map<String, dynamic> data;

  const ResultAnalisisWindowIn({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Parsing nilai dari data
    double rusakBerat = data["rusak_berat"] ?? 0.0;
    double rusakSedang = data["rusak_sedang"] ?? 0.0;
    double rusakRingan = data["rusak_ringan"] ?? 0.0;

    return SizedBox(
      width: 350,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text("Persenan tingkat kerusakan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: CardPersenanRusak(
                  rusakBerat: rusakBerat,
                  rusakSedang: rusakSedang,
                  rusakRingan: rusakRingan,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
