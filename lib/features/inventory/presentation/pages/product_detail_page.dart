import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_app/core/constants/app_constants.dart';
import 'package:inventory_app/core/theme/app_colors.dart';
import 'package:inventory_app/core/utils/currency_formatter.dart';
import 'package:inventory_app/features/inventory/data/models/product.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/category_picker.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/date_group_helper.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/movement_card.dart';
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
      _priceController.addListener(() => setState(() {}));
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

      final quantity = int.tryParse(_quantityController.text);
      final price = double.tryParse(_priceController.text.replaceAll(',', '.'));
      final minStock = int.tryParse(_minStockController.text);

      if (quantity == null || price == null || minStock == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.invalidNumber)),
        );
        return;
      }

      final updated = Product(
        id: product.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        quantity: quantity,
        price: price,
        category: _selectedCategory,
        sku: _skuController.text.trim().isEmpty
            ? null
            : _skuController.text.trim(),
        minStock: minStock,
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
              child: const Icon(Icons.swap_horiz),
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
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          _buildDetailRow(l10n.categoryLabel, product.category ?? l10n.noCategory),
          _buildDetailRow(l10n.priceLabelNoStar, formatCurrency(context, product.price)),
          _buildDetailRow(l10n.quantityLabelNoStar, product.quantity.toString()),
          _buildDetailRow(l10n.minStockLabelNoStar, product.minStock.toString()),
          if (product.sku != null && product.sku!.isNotEmpty)
            _buildDetailRow(l10n.skuLabel, product.sku!),
          if (product.description != null && product.description!.isNotEmpty)
            _buildDetailRow(l10n.descriptionLabel, product.description!),
          const SizedBox(height: 16),
          Text(
            l10n.createdDate(product.createdAt.toLocal().toString().split('.').first),
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          Text(
            l10n.updatedDate(product.updatedAt.toLocal().toString().split('.').first),
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          _buildMovementSection(product),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
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
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
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
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                      child: Text(
                        group.label,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                    ...group.movements.map((m) {
                      return MovementCard(
                        movement: m,
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              maxLength: 50,
              buildCounter: (context,
                  {currentLength = 0, maxLength, isFocused = false, required}) {
                return Text(
                  '$currentLength/$maxLength',
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 12),
                );
              },
              decoration: InputDecoration(
                labelText: l10n.productNameLabel,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.required;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLength: 100,
              buildCounter: (context,
                  {currentLength = 0, maxLength, isFocused = false, required}) {
                return Text(
                  '$currentLength/$maxLength',
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 12),
                );
              },
              decoration: InputDecoration(
                labelText: l10n.descriptionLabel,
              ),
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
                    keyboardType: TextInputType.numberWithOptions(
                        signed: false, decimal: false),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      labelText: l10n.quantityLabel,
                    ),
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
                    keyboardType: TextInputType.numberWithOptions(
                        signed: false, decimal: false),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      labelText: l10n.minStockLabel,
                    ),
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
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*[,.]?\d{0,2}')),
                    ],
                    decoration: InputDecoration(
                      labelText: l10n.priceLabel,
                      suffixText: _priceController.text.isNotEmpty
                          ? Localizations.localeOf(context).languageCode == 'es'
                              ? ' €'
                              : ' \$'
                          : null,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.required;
                      }
                      final number =
                          double.tryParse(value.replaceAll(',', '.'));
                      if (number == null || number < 0) {
                        return l10n.invalidPrice;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _skuController,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: false, decimal: false),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      labelText: l10n.skuLabel,
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
