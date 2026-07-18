import 'package:flutter/material.dart';
import 'package:inventory_app/features/inventory/data/models/product.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/stock_indicator.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: StockIndicator(
        quantity: product.quantity,
        minStock: product.minStock,
      ),
      title: Text(product.name),
      subtitle: Text(
        '${product.category ?? "Sin categoría"} · \$${product.price.toStringAsFixed(2)} · Qty: ${product.quantity}',
      ),
      trailing: onDelete != null
          ? IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            )
          : null,
      onTap: onTap,
    );
  }
}
