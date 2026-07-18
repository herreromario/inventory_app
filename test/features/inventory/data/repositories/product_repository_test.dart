import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:inventory_app/features/inventory/data/models/product.dart';
import 'package:inventory_app/features/inventory/data/repositories/product_repository.dart';

void main() {
  late Box box;
  late ProductRepository repository;

  setUpAll(() async {
    Hive.init('.');
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProductAdapter());
    }
  });

  setUp(() async {
    box = await Hive.openBox('testRepoBox');
    repository = ProductRepository(box);
  });

  tearDown(() async {
    await box.clear();
    await box.close();
  });

  Product createProduct({
    String id = 'test-id',
    String name = 'Test Product',
    int quantity = 10,
    double price = 9.99,
    String category = 'Test',
    int minStock = 5,
  }) {
    return Product(
      id: id,
      name: name,
      quantity: quantity,
      price: price,
      category: category,
      minStock: minStock,
    );
  }

  group('ProductRepository', () {
    test('getProducts returns empty list initially', () {
      final products = repository.getProducts();
      expect(products, isEmpty);
    });

    test('add stores a product', () {
      final product = createProduct();
      repository.add(product);

      final products = repository.getProducts();
      expect(products, hasLength(1));
      expect(products.first.name, equals('Test Product'));
    });

    test('getById returns product when found', () {
      final product = createProduct(id: 'find-me');
      repository.add(product);

      final found = repository.getById('find-me');
      expect(found, isNotNull);
      expect(found!.id, equals('find-me'));
    });

    test('getById returns null when not found', () {
      final found = repository.getById('nonexistent');
      expect(found, isNull);
    });

    test('update modifies existing product', () {
      final product = createProduct(id: 'update-me');
      repository.add(product);

      final updated = product.copyWith(name: 'Updated Name');
      repository.update(updated);

      final products = repository.getProducts();
      expect(products.first.name, equals('Updated Name'));
    });

    test('delete removes product by id', () {
      final product = createProduct(id: 'delete-me');
      repository.add(product);
      expect(repository.getProducts(), hasLength(1));

      repository.delete('delete-me');
      expect(repository.getProducts(), isEmpty);
    });

    test('add multiple products', () {
      repository.add(createProduct(id: 'p1', name: 'Product 1'));
      repository.add(createProduct(id: 'p2', name: 'Product 2'));
      repository.add(createProduct(id: 'p3', name: 'Product 3'));

      expect(repository.getProducts(), hasLength(3));
    });
  });
}
