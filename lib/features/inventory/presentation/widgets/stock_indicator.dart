import 'package:flutter/material.dart';
import 'package:inventory_app/core/theme/app_colors.dart';

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
    return Container(
      width: 6,
      decoration: BoxDecoration(
        color: _getColor(),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Color _getColor() {
    if (quantity < minStock) return AppColors.danger;
    return AppColors.success;
  }
}
