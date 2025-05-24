import 'package:flutter/material.dart';

class CardPersenanRusak extends StatelessWidget {
  final double rusakBerat; // antara 0.0 - 1.0
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF4A4A4A), // warna abu tua
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(25, 0, 0, 0),
            blurRadius: 5,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBar("Rusak berat", rusakBerat, Colors.red),
          const SizedBox(height: 12),
          _buildBar("Rusak sedang", rusakSedang, Colors.amber),
          const SizedBox(height: 12),
          _buildBar("Rusak ringan", rusakRingan, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildBar(String title, double percent, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth * percent.clamp(0.0, 1.0);
                return Stack(
                  children: [
                    Container(
                      width: width,
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
