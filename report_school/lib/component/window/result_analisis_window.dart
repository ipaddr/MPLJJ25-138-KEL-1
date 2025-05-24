import 'package:flutter/material.dart';
import 'package:report_school/component/card_view/card_detail_laporan_analisis.dart';
import '../../component/card_view/card_persenan_rusak.dart';

class ResultAnalisisWindow extends StatelessWidget {
  const ResultAnalisisWindow({super.key});

  @override
  Widget build(BuildContext context) {
    // Ukuran window yang diinginkan
    const double windowWidth = 350.0;

    return SizedBox(
      width: windowWidth,
        child: Card(
          elevation: 5.0, // Memberikan efek bayangan pada Card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Membuat sudut Card melengkung
          ),
        child:  SingleChildScrollView( // Pakai scroll agar tidak overflow
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CardDetailLaporanAnalisis(),
                // === Tambahkan CardFilePendukung di sini ===

                const SizedBox(height: 16), // Jarak antar Card

                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                  child: 
                    Text(
                      'Persenan tingkat kerusakan',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                ),

                const SizedBox(height: 8), // Jarak antar Card

                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: CardPersenanRusak(
                      rusakBerat: 0.2,
                      rusakSedang: 0.4,
                      rusakRingan: 0.8,
                    ),
                ),

                const SizedBox(height: 16), // Jarak antar Card
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
