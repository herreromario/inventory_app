import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:inventory_app/features/inventory/data/models/category.dart';
import 'package:inventory_app/features/inventory/data/repositories/category_repository.dart';
import 'package:inventory_app/features/inventory/presentation/pages/filter_page.dart';
import 'package:inventory_app/features/inventory/providers/category_providers.dart';
import 'package:inventory_app/l10n/app_localizations.dart';

void main() {
  late Box box;
  late CategoryRepository repository;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Hive.init('.');
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CategoryAdapter());
    }
  });

  setUp(() async {
    box = await Hive.openBox('filterPageTestBox');
    repository = CategoryRepository(box);
  });

  tearDown(() async {
    await box.clear();
    await box.close();
  });

  Widget buildTestWidget() {
    return ProviderScope(
      overrides: [
        categoryRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: const FilterPage(),
      ),
    );
  }

  group('FilterPage', () {
    testWidgets('renders category and stock status options', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text('Category'), findsOneWidget);
      expect(find.text('Stock Status'), findsOneWidget);
    });

    testWidgets('shows all categories as default', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text('All categories'), findsOneWidget);
    });

    testWidgets('shows All as default stock status', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text('All'), findsOneWidget);
    });

    testWidgets('shows show results button', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text('Show results'), findsOneWidget);
    });

    testWidgets('show results button is disabled when no filters active',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });
  });
}
