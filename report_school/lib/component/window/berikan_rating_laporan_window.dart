import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/laporan.dart';
import '../../providers/laporan_provider.dart';


class BerikanRatingLaporanWindow extends StatelessWidget {
  final Laporan laporan;

  const BerikanRatingLaporanWindow({super.key, required this.laporan});

  @override
  Widget build(BuildContext context) {
    double currentRating = laporan.rating;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Berikan Rating laporan",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                iconSize: 32,
                icon: Icon(
                  index < currentRating ? Icons.star : Icons.star_border,
                  color: index < currentRating ? Colors.orange : Colors.grey,
                ),
                onPressed: () {
                  Provider.of<LaporanProvider>(context, listen: false)
                      .rateLaporan(laporan, index + 1.0);
                  Navigator.pop(context); // tutup window setelah pilih
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
