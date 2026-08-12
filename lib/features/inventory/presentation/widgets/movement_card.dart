import 'package:flutter/material.dart';
import 'package:inventory_app/features/inventory/data/models/stock_movement.dart';
import 'package:inventory_app/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black87),
            ),
          Text(
            '${isEntry ? l10n.entry : l10n.exit} · ${l10n.quantityAbbreviation}: ${movement.quantity}',
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
