import 'package:hive_ce/hive.dart';
import 'package:inventory_app/features/inventory/data/models/product.dart';

class ProductRepository {
  final Box _box;
  static const String _key = 'PRODUCTS_LIST';

  ProductRepository(this._box);

  List<Product> getProducts() {
    return List<Product>.from(_box.get(_key) ?? []);
  }

  void saveProducts(List<Product> products) {
    _box.put(_key, products);
  }
}
