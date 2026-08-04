import 'package:flutter/material.dart';
import 'package:inventory_app/features/inventory/data/models/stock_movement.dart';

class RecentMovements extends StatelessWidget {
  final List<StockMovement> movements;
  final Map<String, String> productNames;

  const RecentMovements({
    super.key,
    required this.movements,
    required this.productNames,
  });

  @override
  Widget build(BuildContext context) {
    if (movements.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Últimos movimientos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: movements.length,
              separatorBuilder: (_, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final movement = movements[index];
                final isEntry = movement.type == MovementType.entry;
                final productName = productNames[movement.productId] ?? 'Producto desconocido';
                final dateStr = '${movement.date.day.toString().padLeft(2, '0')}/${movement.date.month.toString().padLeft(2, '0')}/${movement.date.year} ${movement.date.hour.toString().padLeft(2, '0')}:${movement.date.minute.toString().padLeft(2, '0')}';

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    isEntry ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isEntry ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  title: Text(
                    productName,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    '${isEntry ? "Entrada" : "Salida"} · Qty: ${movement.quantity} · $dateStr',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  trailing: Text(
                    movement.reason,
                    style: TextStyle(color: Colors.grey[500], fontSize: 11),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
