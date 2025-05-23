import 'package:flutter/material.dart';

class StarCount extends StatelessWidget {
  final double rating;
  final void Function(int)? onStarTap;

  const StarCount({
    super.key,
    required this.rating,
    this.onStarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(5, (index) {
        IconData icon;
        if (rating >= index + 1) {
          icon = Icons.star;
        } else if (rating > index && rating < index + 1) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }

        return GestureDetector(
          onTap: onStarTap != null ? () => onStarTap!(index + 1) : null,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Icon(
              icon,
              color: Colors.amber,
              size: 18,
            ),
          ),
        );
      }),
    );
  }
}
