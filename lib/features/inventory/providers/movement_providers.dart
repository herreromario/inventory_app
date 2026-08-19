import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:inventory_app/features/inventory/data/models/stock_movement.dart';
import 'package:inventory_app/features/inventory/data/repositories/movement_repository.dart';
import 'package:inventory_app/features/inventory/providers/inventory_providers.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

final movementRepositoryProvider = Provider<MovementRepository>((ref) {
  final box = Hive.box('inventoryBox');
  return MovementRepository(box);
});

final movementProvider =
    StateNotifierProvider<MovementNotifier, List<StockMovement>>((ref) {
  final repository = ref.watch(movementRepositoryProvider);
  final inventoryNotifier = ref.watch(inventoryProvider.notifier);
  return MovementNotifier(repository, inventoryNotifier);
});

class MovementNotifier extends StateNotifier<List<StockMovement>> {
  final MovementRepository _repository;
  final InventoryNotifier _inventoryNotifier;

  MovementNotifier(this._repository, this._inventoryNotifier) : super([]) {
    _loadMovements();
  }

  void _loadMovements() {
    state = _repository.getMovements();
  }

  List<StockMovement> getMovementsByProduct(String productId) {
    return state.where((m) => m.productId == productId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  void addMovement({
    required String productId,
    required MovementType type,
    required int quantity,
    required String reason,
  }) {
    if (type == MovementType.exit) {
      final product =
          _inventoryNotifier.getProductById(productId);
      if (product == null) {
        throw Exception('Product not found');
      }
      if (quantity > product.quantity) {
        throw Exception(
            'Insufficient stock: available ${product.quantity}, requested $quantity');
      }
    }

    final movement = StockMovement(
      id: _uuid.v4(),
      productId: productId,
      type: type,
      quantity: quantity,
      reason: reason,
    );

    state = [...state, movement];
    _repository.add(movement);

    final product = _inventoryNotifier.getProductById(productId);
    if (product != null) {
      final newQuantity = type == MovementType.entry
          ? product.quantity + quantity
          : product.quantity - quantity;
      _inventoryNotifier.updateProduct(
        productId,
        product.copyWith(quantity: newQuantity),
      );
    }
  }

  StockMovement? getMovementById(String id) {
    try {
      return state.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  void deleteMovement(String id) {
    final movement = getMovementById(id);
    if (movement == null) return;

    final product = _inventoryNotifier.getProductById(movement.productId);
    if (product != null) {
      final newQuantity = movement.type == MovementType.entry
          ? product.quantity - movement.quantity
          : product.quantity + movement.quantity;
      if (newQuantity < 0) {
        throw Exception(
            'Cannot delete movement: would result in negative stock ($newQuantity)');
      }
      _inventoryNotifier.updateProduct(
        movement.productId,
        product.copyWith(quantity: newQuantity),
      );
    }

    state = [
      for (final m in state)
        if (m.id != id) m,
    ];
    _repository.delete(id);
  }

  void updateMovement(String id, StockMovement updated) {
    final old = getMovementById(id);
    if (old == null) return;

    final product = _inventoryNotifier.getProductById(updated.productId);
    if (product == null) return;

    final oldQty = old.type == MovementType.entry ? old.quantity : -old.quantity;
    final newQty = updated.type == MovementType.entry ? updated.quantity : -updated.quantity;
    final diff = newQty - oldQty;
    final finalQty = product.quantity + diff;

    if (finalQty < 0) {
      throw Exception(
          'Insufficient stock: available ${product.quantity}, result would be $finalQty');
    }

    _inventoryNotifier.updateProduct(
      updated.productId,
      product.copyWith(quantity: finalQty),
    );

    state = [
      for (final m in state)
        if (m.id == id) updated else m,
    ];
    _repository.update(updated);
  }
}
