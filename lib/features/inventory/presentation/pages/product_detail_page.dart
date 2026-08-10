import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_app/core/constants/app_constants.dart';
import 'package:inventory_app/core/utils/currency_formatter.dart';
import 'package:inventory_app/features/inventory/data/models/product.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/category_picker.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/date_group_helper.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/movement_card.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/stock_indicator.dart';
import 'package:inventory_app/features/inventory/providers/inventory_providers.dart';
import 'package:inventory_app/features/inventory/providers/movement_providers.dart';
import 'package:inventory_app/l10n/app_localizations.dart';
import 'package:inventory_app/shared/widgets/confirm_dialog.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  const ProductDetailPage({super.key});

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  late TextEditingController _skuController;
  late TextEditingController _minStockController;
  String? _selectedCategory;
  final _formKey = GlobalKey<FormState>();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initControllers();
    }
  }

  void _initControllers() {
    final product = _getProduct();
    if (product != null) {
      _nameController = TextEditingController(text: product.name);
      _descriptionController =
          TextEditingController(text: product.description ?? '');
      _quantityController =
          TextEditingController(text: product.quantity.toString());
      _priceController =
          TextEditingController(text: product.price.toString());
      _selectedCategory = product.category;
      _skuController = TextEditingController(text: product.sku ?? '');
      _minStockController =
          TextEditingController(text: product.minStock.toString());
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _skuController.dispose();
    _minStockController.dispose();
    super.dispose();
  }

  String? _getProductId() {
    final uri = GoRouterState.of(context).uri.toString();
    final segments = uri.split('/');
    return segments.length > 2 ? segments[2] : null;
  }

  Product? _getProduct() {
    final id = _getProductId();
    if (id == null) return null;
    return ref.read(inventoryProvider.notifier).getProductById(id);
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final l10n = AppLocalizations.of(context)!;
      final product = _getProduct();
      if (product == null) return;

      final updated = Product(
        id: product.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        quantity: int.parse(_quantityController.text),
        price: double.parse(_priceController.text),
        category: _selectedCategory,
        sku: _skuController.text.trim().isEmpty
            ? null
            : _skuController.text.trim(),
        minStock: int.parse(_minStockController.text),
        createdAt: product.createdAt,
      );

      ref.read(inventoryProvider.notifier).updateProduct(product.id, updated);
      setState(() => _isEditing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.productUpdated)),
      );
    }
  }

  void _confirmDelete() async {
    final product = _getProduct();
    if (product == null) return;

    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: l10n.deleteProduct,
      message: l10n.confirmDeleteProduct(product.name),
    );

    if (confirmed && mounted) {
      ref.read(inventoryProvider.notifier).deleteProduct(product.id);
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = _getProduct();
    final l10n = AppLocalizations.of(context)!;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.productDetail)),
        body: Center(child: Text(l10n.productNotFound)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editProduct : l10n.productDetail),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      floatingActionButton: !_isEditing
          ? FloatingActionButton(
              onPressed: () {
                context.push(
                  '${AppRoutes.addMovement}?productId=${product.id}',
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: _isEditing ? _buildEditForm() : _buildDetail(product),
    );
  }

  Widget _buildDetail(Product product) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StockIndicator(
                quantity: product.quantity,
                minStock: product.minStock,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  product.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildDetailRow(l10n.categoryLabel, product.category ?? l10n.noCategory),
          _buildDetailRow(l10n.priceLabel, formatCurrency(context, product.price)),
          _buildDetailRow(l10n.quantityLabel, product.quantity.toString()),
          _buildDetailRow(l10n.minStockLabel, product.minStock.toString()),
          if (product.sku != null && product.sku!.isNotEmpty)
            _buildDetailRow(l10n.skuLabel, product.sku!),
          if (product.description != null && product.description!.isNotEmpty)
            _buildDetailRow(l10n.descriptionLabel, product.description!),
          const SizedBox(height: 16),
          Text(
            l10n.createdDate(product.createdAt.toLocal().toString().split('.').first),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            l10n.updatedDate(product.updatedAt.toLocal().toString().split('.').first),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          _buildMovementSection(product),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildMovementSection(Product product) {
    final movements = ref.watch(movementProvider);
    final l10n = AppLocalizations.of(context)!;
    final productMovements = movements
        .where((m) => m.productId == product.id)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    final groups = groupMovementsByDate(productMovements, l10n);

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text(
          l10n.movementHistoryCount(productMovements.length),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          if (productMovements.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.noMovementsYet),
            )
          else
            ...groups.map((group) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                      child: Text(
                        group.label,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ...group.movements.map((m) {
                          return MovementCard(
                            movement: m,
                            onEdit: () {
                              context.push(
                                '${AppRoutes.addMovement}?movementId=${m.id}',
                              );
                            },
                            onDelete: () async {
                              final confirmed = await ConfirmDialog.show(
                                context: context,
                                title: l10n.deleteMovement,
                                message: l10n.confirmDeleteMovement,
                              );
                              if (confirmed && mounted) {
                                ref
                                    .read(movementProvider.notifier)
                                    .deleteMovement(m.id);
                              }
                            },
                          );
                        }),
                  ],
                )),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.productNameLabel,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.productNameRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: l10n.descriptionLabel,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            CategoryPicker(
              selectedCategory: _selectedCategory,
              onSelected: (category) {
                setState(() => _selectedCategory = category);
              },
              ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: l10n.quantityLabel,
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.required;
                      }
                      final number = int.tryParse(value);
                      if (number == null || number < 0) {
                        return l10n.invalidNumber;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _minStockController,
                    decoration: InputDecoration(
                      labelText: l10n.minStockLabel,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.required;
                      }
                      final number = int.tryParse(value);
                      if (number == null || number < 0) {
                        return l10n.invalidNumber;
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: l10n.priceLabel,
                      border: const OutlineInputBorder(),
                      prefixText: Localizations.localeOf(context).languageCode == 'es' ? '€ ' : '\$ ',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.required;
                      }
                      final number = double.tryParse(value);
                      if (number == null || number < 0) {
                        return l10n.invalidNumber;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _skuController,
                    decoration: InputDecoration(
                      labelText: l10n.skuLabel,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: Text(l10n.saveChanges),
            ),
          ],
        ),
      ),
    );
  }
}
