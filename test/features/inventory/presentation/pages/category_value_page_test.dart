import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:inventory_app/features/inventory/data/models/product.dart';
import 'package:inventory_app/features/inventory/data/models/stock_movement.dart';
import 'package:inventory_app/features/inventory/data/repositories/movement_repository.dart';
import 'package:inventory_app/features/inventory/data/repositories/product_repository.dart';
import 'package:inventory_app/features/inventory/presentation/pages/category_value_page.dart';
import 'package:inventory_app/features/inventory/providers/inventory_providers.dart';
import 'package:inventory_app/features/inventory/providers/movement_providers.dart';

void main() {
  late Box box;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
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
    box = await Hive.openBox('categoryValueTestBox');
    await box.clear();
  });

  tearDown(() async {
    await box.clear();
    await box.close();
  });

  Widget buildTestWidget() {
    return ProviderScope(
      overrides: [
        productRepositoryProvider.overrideWithValue(
          ProductRepository(box),
        ),
        movementRepositoryProvider.overrideWithValue(
          MovementRepository(box),
        ),
      ],
      child: const MaterialApp(home: CategoryValuePage()),
    );
  }

  group('CategoryValuePage', () {
    testWidgets('shows empty state when no data', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();
      await tester.pump();

      expect(find.text('Valor por categoría'), findsOneWidget);
      expect(find.text('No hay datos disponibles'), findsOneWidget);
    });

    testWidgets('shows total value when products exist', (tester) async {
      final repository = ProductRepository(box);
      repository.add(
        Product(
          id: '1',
          name: 'Laptop',
          quantity: 10,
          price: 999.99,
          minStock: 2,
          category: 'Electronics',
        ),
      );

      await tester.pumpWidget(buildTestWidget());
      await tester.pump();
      await tester.pump();

      expect(find.text('Total del inventario'), findsOneWidget);
      expect(find.textContaining('\$'), findsWidgets);
    });
  });
}
