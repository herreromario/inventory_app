import 'package:flutter/material.dart';

class StockIndicator extends StatelessWidget {
  final int quantity;

  const StockIndicator({super.key, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.circle,
      color: _getColor(),
      size: 12,
    );
  }

  Color _getColor() {
    if (quantity <= 5) return Colors.red;
    if (quantity <= 15) return Colors.amber;
    return Colors.green;
  }
}
