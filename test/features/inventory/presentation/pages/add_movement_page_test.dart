import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:inventory_app/features/inventory/data/models/product.dart';
import 'package:inventory_app/features/inventory/data/models/stock_movement.dart';
import 'package:inventory_app/features/inventory/data/repositories/movement_repository.dart';
import 'package:inventory_app/features/inventory/data/repositories/product_repository.dart';
import 'package:inventory_app/features/inventory/presentation/pages/add_movement_page.dart';
import 'package:inventory_app/features/inventory/providers/inventory_providers.dart';
import 'package:inventory_app/features/inventory/providers/movement_providers.dart';
import 'package:inventory_app/l10n/app_localizations.dart';

void main() {
  late Box box;
  late ProductRepository productRepository;
  late MovementRepository movementRepository;

  setUpAll(() async {
    final dir = Directory.systemTemp.createTempSync('hive_add_movement_');
    Hive.init(dir.path);
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
    box = await Hive.openBox('addMovementPageBox');
    productRepository = ProductRepository(box);
    movementRepository = MovementRepository(box);
  });

  Widget buildTestWidget({String? productId}) {
    return ProviderScope(
      overrides: [
        productRepositoryProvider.overrideWithValue(productRepository),
        movementRepositoryProvider.overrideWithValue(movementRepository),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: AddMovementPage(productId: productId),
      ),
    );
  }

  group('AddMovementPage', () {
    testWidgets('renders form fields', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();
      await tester.pump();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Add Movement'), findsOneWidget);
      expect(find.text('Quantity *'), findsOneWidget);
      expect(find.text('Reason *'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('validates quantity and reason on submit', (tester) async {
      productRepository.add(Product(
        id: 'test-id',
        name: 'Test Product',
        quantity: 10,
        price: 9.99,
        category: 'Test',
        minStock: 5,
      ));

      await tester.pumpWidget(buildTestWidget(productId: 'test-id'));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      await tester.pump();

      expect(find.text('Required'), findsWidgets);
    });
  });
}
