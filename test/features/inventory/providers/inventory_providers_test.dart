import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:inventory_app/features/inventory/data/models/product.dart';
import 'package:inventory_app/features/inventory/data/repositories/product_repository.dart';
import 'package:inventory_app/features/inventory/providers/inventory_providers.dart';

void main() {
  late Box box;
  late ProductRepository repository;
  late InventoryNotifier notifier;

  setUpAll(() async {
    Hive.init('.');
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProductAdapter());
    }
  });

  setUp(() async {
    box = await Hive.openBox('testNotifierBox');
    repository = ProductRepository(box);
    notifier = InventoryNotifier(repository);
  });

  tearDown(() async {
    await box.clear();
    await box.close();
  });

  group('InventoryNotifier', () {
    test('initial state is empty list', () {
      expect(notifier.state, isEmpty);
    });

    test('addProduct adds product to state', () {
      notifier.addProduct(
        name: 'Test Product',
        quantity: 10,
        price: 9.99,
        category: 'Test',
        minStock: 5,
      );

      expect(notifier.state, hasLength(1));
      expect(notifier.state.first.name, equals('Test Product'));
    });

    test('addProduct generates UUID and timestamps', () {
      notifier.addProduct(
        name: 'Test Product',
        quantity: 10,
        price: 9.99,
        category: 'Test',
        minStock: 5,
      );

      final product = notifier.state.first;
      expect(product.id, isNotEmpty);
      expect(product.createdAt, isNotNull);
      expect(product.updatedAt, isNotNull);
    });

    test('getProductById returns product', () {
      notifier.addProduct(
        name: 'Find Me',
        quantity: 5,
        price: 19.99,
        category: 'Search',
        minStock: 2,
      );

      final id = notifier.state.first.id;
      final found = notifier.getProductById(id);
      expect(found, isNotNull);
      expect(found!.name, equals('Find Me'));
    });

    test('getProductById returns null for nonexistent id', () {
      expect(notifier.getProductById('nonexistent'), isNull);
    });

    test('deleteProduct removes product from state', () {
      notifier.addProduct(
        name: 'To Delete',
        quantity: 1,
        price: 1.0,
        category: 'Delete',
        minStock: 0,
      );

      final id = notifier.state.first.id;
      notifier.deleteProduct(id);

      expect(notifier.state, isEmpty);
    });

    test('updateProduct modifies product in state', () {
      notifier.addProduct(
        name: 'Original',
        quantity: 10,
        price: 5.0,
        category: 'Update',
        minStock: 3,
      );

      final product = notifier.state.first;
      final updated = product.copyWith(name: 'Modified');
      notifier.updateProduct(product.id, updated);

      expect(notifier.state.first.name, equals('Modified'));
    });

    test('addProduct persists to repository', () {
      notifier.addProduct(
        name: 'Persistent',
        quantity: 7,
        price: 12.50,
        category: 'Persist',
        minStock: 2,
      );

      final fromRepo = repository.getProducts();
      expect(fromRepo, hasLength(1));
      expect(fromRepo.first.name, equals('Persistent'));
    });
  });
}
