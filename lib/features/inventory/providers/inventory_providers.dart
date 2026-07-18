import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:inventory_app/features/inventory/data/models/product.dart';
import 'package:inventory_app/features/inventory/data/repositories/product_repository.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final box = Hive.box('inventoryBox');
  return ProductRepository(box);
});

final inventoryProvider =
    StateNotifierProvider<InventoryNotifier, List<Product>>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return InventoryNotifier(repository);
});

class InventoryNotifier extends StateNotifier<List<Product>> {
  final ProductRepository _repository;

  InventoryNotifier(this._repository) : super([]) {
    _loadProducts();
  }

  void _loadProducts() {
    state = _repository.getProducts();
  }

  Product? getProductById(String id) {
    try {
      return state.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  void addProduct({
    required String name,
    String? description,
    required int quantity,
    required double price,
    String? category,
    String? sku,
    required int minStock,
  }) {
    final now = DateTime.now();
    final product = Product(
      id: _uuid.v4(),
      name: name,
      description: description,
      quantity: quantity,
      price: price,
      category: category,
      sku: sku,
      minStock: minStock,
      createdAt: now,
      updatedAt: now,
    );
    state = [...state, product];
    _repository.add(product);
  }

  void updateProduct(String id, Product updated) {
    state = [
      for (final p in state)
        if (p.id == id) updated else p,
    ];
    _repository.update(updated);
  }

  void deleteProduct(String id) {
    state = [
      for (final p in state)
        if (p.id != id) p,
    ];
    _repository.delete(id);
  }
}
