import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_app/core/constants/app_constants.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/product_card.dart';
import 'package:inventory_app/features/inventory/providers/inventory_providers.dart';
import 'package:inventory_app/shared/widgets/empty_state.dart';

class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(inventoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addProduct),
        child: const Icon(Icons.add),
      ),
      body: products.isEmpty
          ? const EmptyState(message: 'No products yet')
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onDelete: () {
                    ref.read(inventoryProvider.notifier).deleteProduct(product.id);
                  },
                );
              },
            ),
    );
  }
}
