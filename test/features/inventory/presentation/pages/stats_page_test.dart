import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:inventory_app/features/inventory/data/models/product.dart';
import 'package:inventory_app/features/inventory/data/models/stock_movement.dart';
import 'package:inventory_app/features/inventory/data/repositories/movement_repository.dart';
import 'package:inventory_app/features/inventory/data/repositories/product_repository.dart';
import 'package:inventory_app/features/inventory/presentation/pages/stats_page.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/stats_empty_view.dart';
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
    box = await Hive.openBox('statsPageTestBox');
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
      child: const MaterialApp(home: StatsPage()),
    );
  }

  group('StatsPage', () {
    testWidgets('shows Dashboard title', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text('Dashboard'), findsOneWidget);
    });

    testWidgets('shows empty state when no data', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(find.byType(StatsEmptyView), findsOneWidget);
    });

    testWidgets('shows stats cards when products exist', (tester) async {
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
      await tester.pump();

      expect(find.text('Total productos'), findsOneWidget);
      expect(find.text('Valor total'), findsOneWidget);
    });
  });
}
