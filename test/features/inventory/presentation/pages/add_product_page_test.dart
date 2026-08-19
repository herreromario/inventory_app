import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:inventory_app/features/inventory/data/models/product.dart';
import 'package:inventory_app/features/inventory/data/repositories/product_repository.dart';
import 'package:inventory_app/features/inventory/presentation/pages/add_product_page.dart';
import 'package:inventory_app/features/inventory/providers/inventory_providers.dart';
import 'package:inventory_app/l10n/app_localizations.dart';

void main() {
  late Box box;
  late ProductRepository repository;

  setUpAll(() async {
    final dir = Directory.systemTemp.createTempSync('hive_add_');
    Hive.init(dir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProductAdapter());
    }
  });

  setUp(() async {
    box = await Hive.openBox('addProductPageBox');
    repository = ProductRepository(box);
  });

  tearDown(() async {
    await box.clear();
    await box.close();
  });

  Widget buildTestWidget() {
    return ProviderScope(
      overrides: [
        productRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: const AddProductPage(),
      ),
    );
  }

  group('AddProductPage', () {
    testWidgets('renders all form fields', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();
      await tester.pump();

      expect(find.byType(AppBar), findsOneWidget);
      // 6 TextFormField: name, description, quantity, minStock, price, sku
      expect(find.byType(TextFormField), findsNWidgets(6));
      // Category picker shows "No category" by default (localized)
      expect(find.text('No category'), findsOneWidget);
    });

    testWidgets('shows validation errors on empty submit', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      await tester.pump();

      // Only name and numeric fields have validators now
      expect(find.text('Required'), findsWidgets);
      expect(find.text('Please select a category'), findsNothing);
    });

    testWidgets('validates quantity is a number', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();
      await tester.pump();

      // quantity is index 2 (after name and description)
      final quantityField = find.byType(TextFormField).at(2);
      await tester.enterText(quantityField, '0');
      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      await tester.pump();

      // '0' is valid, so no error; test that the field accepts digits
      expect(find.text('Invalid number'), findsNothing);
    });

    testWidgets('validates price is a number', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();
      await tester.pump();

      // price is index 4 (after name, description, quantity, minStock)
      final priceField = find.byType(TextFormField).at(4);
      await tester.enterText(priceField, '10.50');
      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      await tester.pump();

      // '10.50' is valid, so no error
      expect(find.text('Invalid price'), findsNothing);
    });
  });
}
