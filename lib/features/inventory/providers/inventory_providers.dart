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

  void addProduct({
    required String name,
    String? description,
    required int quantity,
  }) {
    final product = Product(
      id: _uuid.v4(),
      name: name,
      description: description,
      quantity: quantity,
    );
    state = [...state, product];
    _repository.saveProducts(state);
  }

  void deleteProduct(String id) {
    state = [
      for (final product in state)
        if (product.id != id) product,
    ];
    _repository.saveProducts(state);
  }

  void updateProduct(String id, Product updated) {
    state = [
      for (final product in state)
        if (product.id == id) updated else product,
    ];
    _repository.saveProducts(state);
  }
}
