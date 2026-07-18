import 'package:flutter/material.dart';

class StockIndicator extends StatelessWidget {
  final int quantity;
  final int minStock;

  const StockIndicator({
    super.key,
    required this.quantity,
    required this.minStock,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.circle,
      color: _getColor(),
      size: 12,
    );
  }

  Color _getColor() {
    if (quantity < minStock) return Colors.red;
    if (quantity == minStock) return Colors.amber;
    return Colors.green;
  }
}
