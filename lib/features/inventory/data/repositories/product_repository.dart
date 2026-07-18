import 'package:hive_ce/hive.dart';
import 'package:inventory_app/features/inventory/data/models/product.dart';

class ProductRepository {
  final Box _box;
  static const String _key = 'PRODUCTS_LIST';

  ProductRepository(this._box);

  List<Product> getProducts() {
    return List<Product>.from(_box.get(_key) ?? []);
  }

  Product? getById(String id) {
    final products = getProducts();
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  void add(Product product) {
    final products = getProducts();
    products.add(product);
    _save(products);
  }

  void update(Product updated) {
    final products = getProducts();
    final index = products.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      products[index] = updated;
      _save(products);
    }
  }

  void delete(String id) {
    final products = getProducts();
    products.removeWhere((p) => p.id == id);
    _save(products);
  }

  void _save(List<Product> products) {
    _box.put(_key, products);
  }
}
