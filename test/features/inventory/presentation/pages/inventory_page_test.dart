import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:inventory_app/features/inventory/data/models/product.dart';
import 'package:inventory_app/features/inventory/data/repositories/product_repository.dart';
import 'package:inventory_app/features/inventory/presentation/pages/inventory_page.dart';
import 'package:inventory_app/features/inventory/providers/inventory_providers.dart';
import 'package:inventory_app/l10n/app_localizations.dart';

void main() {
  late Box box;
  late ProductRepository repository;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Hive.init('.');
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProductAdapter());
    }
  });

  setUp(() async {
    box = await Hive.openBox('widgetTestInvBox');
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
        home: const InventoryPage(),
      ),
    );
  }

  group('InventoryPage', () {
    testWidgets('shows empty state when no products', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();
      await tester.pump();

      expect(find.text('No products yet'), findsOneWidget);
    });

    testWidgets('shows FAB for adding products', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
