import 'package:flutter/material.dart';

class CardPersenanRusak extends StatelessWidget {
  final double rusakBerat;
  final double rusakSedang;
  final double rusakRingan;

  const CardPersenanRusak({
    super.key,
    required this.rusakBerat,
    required this.rusakSedang,
    required this.rusakRingan,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildProgressBar("Rusak berat", rusakBerat, Colors.black87),
        _buildProgressBar("Rusak sedang", rusakSedang, Colors.orange),
        _buildProgressBar("Rusak ringan", rusakRingan, Colors.blue),
      ],
    );
  }

  Widget _buildProgressBar(String label, double value, Color color) {
    final percent = (value * 100).clamp(0, 100).toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: value.clamp(0.0, 1.0),
                  backgroundColor: Colors.grey[300],
                  color: color,
                  minHeight: 10,
                ),
              ),
              const SizedBox(width: 8),
              Stack(
                children: [
                  Text(
                    "$percent%",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = Colors.black, // Warna outline
                    ),
                  ),
                  Text(
                    "$percent%",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Warna isi
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
