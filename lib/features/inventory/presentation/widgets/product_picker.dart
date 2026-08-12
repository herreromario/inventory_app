import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_app/core/constants/app_constants.dart';
import 'package:inventory_app/features/inventory/providers/inventory_providers.dart';
import 'package:inventory_app/l10n/app_localizations.dart';

class ProductPicker extends ConsumerWidget {
  final String? selectedProductId;
  final ValueChanged<String?> onSelected;

  const ProductPicker({
    super.key,
    this.selectedProductId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final product = selectedProductId != null
        ? ref
            .read(inventoryProvider.notifier)
            .getProductById(selectedProductId!)
        : null;

    return InkWell(
      onTap: () async {
        final result = await context.push<String>(AppRoutes.productPicker);
        if (result != null) {
          onSelected(result);
        }
      },
      child: product != null
          ? Card(
              child: ListTile(
                title: Text(product.name),
                subtitle: Text(l10n.currentStock(product.quantity)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () => onSelected(null),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            )
          : InputDecorator(
              decoration: InputDecoration(
                labelText: l10n.productLabel,
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.chevron_right),
              ),
              child: Text(
                l10n.selectProduct,
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
            ),
    );
  }
}
