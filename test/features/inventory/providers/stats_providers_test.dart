import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:inventory_app/features/inventory/data/models/product.dart';
import 'package:inventory_app/features/inventory/data/models/stock_movement.dart';
import 'package:inventory_app/features/inventory/providers/stats_providers.dart';

void main() {
  late Box box;

  setUpAll(() async {
    Hive.init('.');
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProductAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(StockMovementAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(MovementTypeAdapter());
    }
  });

  setUp(() async {
    box = await Hive.openBox('testStatsBox');
  });

  tearDown(() async {
    await box.clear();
    await box.close();
  });

  group('InventoryStats', () {
    test('isEmpty returns true when totalProducts is 0', () {
      const stats = InventoryStats(
        totalProducts: 0,
        totalValue: 0,
        lowStockCount: 0,
        recentMovements: [],
        valueByCategory: {},
      );
      expect(stats.isEmpty, isTrue);
    });

    test('isEmpty returns false when totalProducts > 0', () {
      const stats = InventoryStats(
        totalProducts: 5,
        totalValue: 100,
        lowStockCount: 1,
        recentMovements: [],
        valueByCategory: {'Electronics': 5000.0},
      );
      expect(stats.isEmpty, isFalse);
    });

    test('topCategories returns sorted by value descending', () {
      const stats = InventoryStats(
        totalProducts: 10,
        totalValue: 15000,
        lowStockCount: 0,
        recentMovements: [],
        valueByCategory: {
          'Clothing': 3000.0,
          'Electronics': 10000.0,
          'Furniture': 5000.0,
        },
      );
      final top = stats.topCategories;
      expect(top.length, equals(3));
      expect(top[0].key, equals('Electronics'));
      expect(top[0].value, equals(10000.0));
      expect(top[1].key, equals('Furniture'));
      expect(top[2].key, equals('Clothing'));
    });
  });

  group('getProductName', () {
    test('returns product name when product exists', () {
      final products = [
        Product(
          id: '1',
          name: 'Laptop',
          quantity: 10,
          price: 999.99,
          minStock: 2,
        ),
        Product(
          id: '2',
          name: 'Mouse',
          quantity: 50,
          price: 29.99,
          minStock: 10,
        ),
      ];

      final name = getProductName(products, '2');
      expect(name, equals('Mouse'));
    });

    test('returns fallback name when product not found', () {
      final products = <Product>[];
      final name = getProductName(products, 'nonexistent');
      expect(name, equals('Producto desconocido'));
    });
  });
}
