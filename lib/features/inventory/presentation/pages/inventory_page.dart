import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_app/core/constants/app_constants.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/product_card.dart';
import 'package:inventory_app/features/inventory/providers/inventory_providers.dart';
import 'package:inventory_app/shared/widgets/confirm_dialog.dart';
import 'package:inventory_app/shared/widgets/empty_state.dart';

class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(inventoryProvider);

    final sorted = List.of(products)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addProduct),
        child: const Icon(Icons.add),
      ),
      body: sorted.isEmpty
          ? const EmptyState(message: 'No products yet')
          : ListView.builder(
              itemCount: sorted.length,
              itemBuilder: (context, index) {
                final product = sorted[index];
                return ProductCard(
                  product: product,
                  onDelete: () async {
                    final confirmed = await ConfirmDialog.show(
                      context: context,
                      title: 'Delete Product',
                      message:
                          'Are you sure you want to delete "${product.name}"?',
                    );
                    if (confirmed && context.mounted) {
                      ref
                          .read(inventoryProvider.notifier)
                          .deleteProduct(product.id);
                    }
                  },
                  onTap: () {
                    context.push(AppRoutes.productDetail(product.id));
                  },
                );
              },
            ),
    );
  }
}
