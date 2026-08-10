import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_app/core/constants/app_constants.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/product_card.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/sort_bottom_sheet.dart';
import 'package:inventory_app/features/inventory/providers/filter_providers.dart';
import 'package:inventory_app/features/inventory/providers/inventory_providers.dart';
import 'package:inventory_app/l10n/app_localizations.dart';
import 'package:inventory_app/shared/widgets/confirm_dialog.dart';
import 'package:inventory_app/shared/widgets/empty_state.dart';

class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(filteredProductsProvider);
    final filter = ref.watch(filterProvider);
    final hasProducts = ref.watch(inventoryProvider).isNotEmpty;

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navInventory)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addProduct),
        child: const Icon(Icons.add),
      ),
      body: hasProducts
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: l10n.searchProducts,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: filter.query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                ref
                                    .read(filterProvider.notifier)
                                    .setQuery('');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      ref.read(filterProvider.notifier).setQuery(value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => context.push(AppRoutes.filters),
                          icon: Badge(
                            label: Text('${filter.activeFilterCount}'),
                            isLabelVisible: filter.activeFilterCount > 0,
                            child: const Icon(Icons.tune, size: 18),
                          ),
                          label: Text(l10n.filters),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => SortBottomSheet.show(context),
                          icon: const Icon(Icons.sort, size: 18),
                          label: Text(l10n.sort),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: products.isEmpty
                      ? EmptyState(message: l10n.noMatchingProducts)
                      : ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductCard(
                              product: product,
                              onDelete: () async {
                                final confirmed = await ConfirmDialog.show(
                                  context: context,
                                  title: l10n.deleteProduct,
                                  message: l10n.confirmDeleteProduct(product.name),
                                );
                                if (confirmed && context.mounted) {
                                  ref
                                      .read(inventoryProvider.notifier)
                                      .deleteProduct(product.id);
                                }
                              },
                              onTap: () {
                                context.push(
                                  AppRoutes.productDetail(product.id),
                                );
                              },
                              onMovement: () {
                                context.push(
                                  '${AppRoutes.addMovement}?productId=${product.id}',
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            )
          : EmptyState(message: l10n.noProductsYet),
    );
  }
}
