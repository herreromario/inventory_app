import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/core/theme/app_colors.dart';
import 'package:inventory_app/features/inventory/providers/inventory_providers.dart';
import 'package:inventory_app/features/inventory/providers/stats_providers.dart';

class CategoryValuePage extends ConsumerWidget {
  const CategoryValuePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);
    final products = ref.watch(inventoryProvider);

    if (stats.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Valor por categoría'),
        ),
        body: const Center(
          child: Text('No hay datos disponibles'),
        ),
      );
    }

    final totalValue = stats.totalValue;
    final sortedCategories = stats.topCategories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Valor por categoría'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.attach_money,
                      color: AppColors.stockGreen,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total del inventario',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        Text(
                          '\$${totalValue.toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${sortedCategories.length} categorías',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sortedCategories.length,
              separatorBuilder: (_, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final entry = sortedCategories[index];
                final categoryValue = entry.value;
                final percentage = totalValue > 0
                    ? (categoryValue / totalValue * 100)
                    : 0.0;

                final categoryProducts = products
                    .where((p) =>
                        (p.category ?? 'Sin categoría') == entry.key)
                    .toList()
                  ..sort((a, b) =>
                      (b.quantity * b.price).compareTo(a.quantity * a.price));
                final top3 = categoryProducts.take(3).toList();

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        entry.key,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '\$${categoryValue.toStringAsFixed(2)} · ${percentage.toStringAsFixed(1)}%',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      children: [
                        if (top3.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('No hay productos'),
                          )
                        else
                          ...top3.map((product) {
                            final productValue = product.quantity * product.price;
                            return ListTile(
                              dense: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              title: Text(product.name),
                              subtitle: Text(
                                'Qty: ${product.quantity} · \$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12),
                              ),
                              trailing: Text(
                                '\$${productValue.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          }),
                        if (categoryProducts.length > 3)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              '+${categoryProducts.length - 3} productos más',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
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
