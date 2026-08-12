import 'package:flutter/material.dart';
import 'package:inventory_app/core/utils/currency_formatter.dart';
import 'package:inventory_app/features/inventory/data/models/product.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/stock_indicator.dart';
import 'package:inventory_app/l10n/app_localizations.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final VoidCallback? onMovement;

  const ProductCard({
    super.key,
    required this.product,
    this.onDelete,
    this.onTap,
    this.onMovement,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      leading: StockIndicator(
        quantity: product.quantity,
        minStock: product.minStock,
      ),
      title: Text(
        product.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${product.category ?? l10n.noCategory} · ${formatCurrency(context, product.price)} · ${l10n.quantityAbbreviation}: ${product.quantity}',
      ),
      trailing: (onDelete != null || onMovement != null)
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onMovement != null)
                  IconButton(
                    icon: const Icon(Icons.swap_horiz),
                    onPressed: onMovement,
                  ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: onDelete,
                  ),
              ],
            )
          : null,
      onTap: onTap,
    );
  }
}
