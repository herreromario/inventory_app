import 'package:flutter/material.dart';
import 'package:inventory_app/features/inventory/data/models/stock_movement.dart';

class MovementCard extends StatelessWidget {
  final StockMovement movement;
  final String? productName;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const MovementCard({
    super.key,
    required this.movement,
    this.productName,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isEntry = movement.type == MovementType.entry;

    return ListTile(
      leading: Icon(
        isEntry ? Icons.arrow_downward : Icons.arrow_upward,
        color: isEntry ? Colors.green : Colors.red,
      ),
      title: Text(movement.reason),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (productName != null)
            Text(
              productName!,
              style: const TextStyle(color: Colors.black87),
            ),
          Text(
            '${isEntry ? "Entry" : "Exit"} · Qty: ${movement.quantity}',
          ),
        ],
      ),
      trailing: (onDelete != null || onEdit != null)
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onEdit != null)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: onEdit,
                  ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: onDelete,
                  ),
              ],
            )
          : null,
    );
  }
}
