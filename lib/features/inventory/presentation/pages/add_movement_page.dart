import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_app/core/theme/app_colors.dart';
import 'package:inventory_app/features/inventory/data/models/stock_movement.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/product_picker.dart';
import 'package:inventory_app/features/inventory/providers/inventory_providers.dart';
import 'package:inventory_app/features/inventory/providers/movement_providers.dart';
import 'package:inventory_app/l10n/app_localizations.dart';

class AddMovementPage extends ConsumerStatefulWidget {
  final String? productId;
  final String? movementId;

  const AddMovementPage({super.key, this.productId, this.movementId});

  @override
  ConsumerState<AddMovementPage> createState() => _AddMovementPageState();
}

class _AddMovementPageState extends ConsumerState<AddMovementPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _reasonController = TextEditingController();
  MovementType _selectedType = MovementType.entry;
  String? _selectedProductId;
  bool _initialized = false;

  bool get _isEditing => widget.movementId != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initForm();
    }
  }

  void _initForm() {
    if (_isEditing) {
      final movement =
          ref.read(movementProvider.notifier).getMovementById(widget.movementId!);
      if (movement != null) {
        _selectedProductId = movement.productId;
        _selectedType = movement.type;
        _quantityController.text = movement.quantity.toString();
        _reasonController.text = movement.reason;
      }
    } else {
      _selectedProductId = widget.productId;
    }
    _initialized = true;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;
    if (_selectedProductId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseSelectProduct)),
      );
      return;
    }

    try {
      final quantity = int.tryParse(_quantityController.text);
      if (quantity == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.invalidNumber)),
        );
        return;
      }

      if (_isEditing) {
        final existing = ref
            .read(movementProvider.notifier)
            .getMovementById(widget.movementId!);
        if (existing == null) return;

        final updated = existing.copyWith(
          type: _selectedType,
          quantity: quantity,
          reason: _reasonController.text.trim(),
        );
        ref.read(movementProvider.notifier).updateMovement(existing.id, updated);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.movementUpdated)),
        );
      } else {
        ref.read(movementProvider.notifier).addMovement(
              productId: _selectedProductId!,
              type: _selectedType,
              quantity: quantity,
              reason: _reasonController.text.trim(),
            );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.movementRegistered)),
        );
      }
      if (mounted) context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final products = ref.watch(inventoryProvider);
    final selectedProduct = _selectedProductId != null
        ? products.where((p) => p.id == _selectedProductId).firstOrNull
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editMovement : l10n.addMovement),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProductPicker(
                selectedProductId: _selectedProductId,
                onSelected: (productId) {
                  setState(() => _selectedProductId = productId);
                },
              ),
              const SizedBox(height: 16),
              SegmentedButton<MovementType>(
                segments: [
                  ButtonSegment(
                    value: MovementType.entry,
                    label: Text(l10n.entry),
                    icon: const Icon(Icons.arrow_downward),
                  ),
                  ButtonSegment(
                    value: MovementType.exit,
                    label: Text(l10n.exit),
                    icon: const Icon(Icons.arrow_upward),
                  ),
                ],
                selected: {_selectedType},
                onSelectionChanged: (selected) {
                  setState(() => _selectedType = selected.first);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return _selectedType == MovementType.entry
                          ? AppColors.success
                          : AppColors.danger;
                    }
                    return null;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return AppColors.onPrimary;
                    }
                    return null;
                  }),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: l10n.quantityLabel,
                ),
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: false),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.required;
                  }
                  final number = int.tryParse(value);
                  if (number == null || number <= 0) {
                    return l10n.mustBePositive;
                  }
                  if (_selectedType == MovementType.exit &&
                      selectedProduct != null &&
                      number > selectedProduct.quantity) {
                    return l10n.cannotExceedStock(selectedProduct.quantity);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _reasonController,
                decoration: InputDecoration(
                  labelText: l10n.reasonLabel,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.required;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save),
                label: Text(_isEditing ? l10n.saveChanges : l10n.registerMovement),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
