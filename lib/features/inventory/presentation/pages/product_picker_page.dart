import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_app/features/inventory/providers/inventory_providers.dart';
import 'package:inventory_app/l10n/app_localizations.dart';

class ProductPickerPage extends ConsumerStatefulWidget {
  const ProductPickerPage({super.key});

  @override
  ConsumerState<ProductPickerPage> createState() => _ProductPickerPageState();
}

class _ProductPickerPageState extends ConsumerState<ProductPickerPage> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(inventoryProvider);
    final l10n = AppLocalizations.of(context)!;

    final filtered = _query.isEmpty
        ? products
        : products
            .where((p) =>
                p.name.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.selectProduct)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchProducts,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
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
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? Center(child: Text(l10n.noProductsYet))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final product = filtered[index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text(
                          '${product.category ?? l10n.noCategory} · ${product.quantity} ${l10n.quantityAbbreviation}',
                        ),
                        onTap: () => context.pop(product.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
