import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_app/core/theme/app_colors.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/category_picker.dart';
import 'package:inventory_app/features/inventory/providers/inventory_providers.dart';
import 'package:inventory_app/l10n/app_localizations.dart';

class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _skuController = TextEditingController();
  final _minStockController = TextEditingController();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _priceController.addListener(() => setState(() {}));
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final l10n = AppLocalizations.of(context)!;
      final quantity = int.tryParse(_quantityController.text);
      final price = double.tryParse(_priceController.text.replaceAll(',', '.'));
      final minStock = int.tryParse(_minStockController.text);

      if (quantity == null || price == null || minStock == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.invalidNumber)),
        );
        return;
      }

      ref.read(inventoryProvider.notifier).addProduct(
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
          );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.productAddedSuccessfully)),
      );

      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addProduct)),
      body: SingleChildScrollView(
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
                        final number = double.tryParse(
                            value.replaceAll(',', '.'));
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
                onPressed: _submit,
                icon: const Icon(Icons.add),
                label: Text(l10n.addProduct),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
