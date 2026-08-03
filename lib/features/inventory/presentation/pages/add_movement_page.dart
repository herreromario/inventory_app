import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_app/features/inventory/data/models/stock_movement.dart';
import 'package:inventory_app/features/inventory/providers/inventory_providers.dart';
import 'package:inventory_app/features/inventory/providers/movement_providers.dart';

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
    if (_selectedProductId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a product')),
      );
      return;
    }

    try {
      if (_isEditing) {
        final existing = ref
            .read(movementProvider.notifier)
            .getMovementById(widget.movementId!);
        if (existing == null) return;

        final updated = existing.copyWith(
          type: _selectedType,
          quantity: int.parse(_quantityController.text),
          reason: _reasonController.text.trim(),
        );
        ref.read(movementProvider.notifier).updateMovement(existing.id, updated);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Movement updated')),
        );
      } else {
        ref.read(movementProvider.notifier).addMovement(
              productId: _selectedProductId!,
              type: _selectedType,
              quantity: int.parse(_quantityController.text),
              reason: _reasonController.text.trim(),
            );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Movement registered')),
        );
      }
      context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(inventoryProvider);
    final selectedProduct = _selectedProductId != null
        ? ref
            .read(inventoryProvider.notifier)
            .getProductById(_selectedProductId!)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Movement' : 'Add Movement'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (selectedProduct != null)
                Card(
                  child: ListTile(
                    title: Text(selectedProduct.name),
                    subtitle: Text(
                      'Current stock: ${selectedProduct.quantity}',
                    ),
                  ),
                )
              else
                DropdownButtonFormField<String>(
                  initialValue: _selectedProductId,
                  decoration: const InputDecoration(
                    labelText: 'Product *',
                    border: OutlineInputBorder(),
                  ),
                  items: products
                      .map((p) => DropdownMenuItem(
                            value: p.id,
                            child: Text(p.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedProductId = value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a product';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 16),
              SegmentedButton<MovementType>(
                segments: const [
                  ButtonSegment(
                    value: MovementType.entry,
                    label: Text('Entry'),
                    icon: Icon(Icons.arrow_downward),
                  ),
                  ButtonSegment(
                    value: MovementType.exit,
                    label: Text('Exit'),
                    icon: Icon(Icons.arrow_upward),
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
                          ? Colors.green
                          : Colors.red;
                    }
                    return null;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.white;
                    }
                    return null;
                  }),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  final number = int.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'Must be a positive number';
                  }
                  if (_selectedType == MovementType.exit &&
                      selectedProduct != null &&
                      number > selectedProduct.quantity) {
                    return 'Cannot exceed available stock (${selectedProduct.quantity})';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save),
                label: Text(_isEditing ? 'Save Changes' : 'Register Movement'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
