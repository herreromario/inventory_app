import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:inventory_app/features/inventory/data/models/category.dart';
import 'package:inventory_app/features/inventory/data/repositories/category_repository.dart';
import 'package:inventory_app/features/inventory/presentation/pages/category_picker_page.dart';
import 'package:inventory_app/features/inventory/providers/category_providers.dart';

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
    box = await Hive.openBox('categoryPickerTestBox');
    repository = CategoryRepository(box);
  });

  tearDown(() async {
    await box.clear();
    await box.close();
  });

  Widget buildTestWidget({String? selectedCategory}) {
    return ProviderScope(
      overrides: [
        categoryRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        home: CategoryPickerPage(selectedCategory: selectedCategory),
      ),
    );
  }

  group('CategoryPickerPage', () {
    testWidgets('renders all categories option', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text('All categories'), findsOneWidget);
    });

    testWidgets('shows categories from repository', (tester) async {
      repository.add(Category(id: '1', name: 'Electronics'));
      repository.add(Category(id: '2', name: 'Food'));

      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text('Electronics'), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);
    });

    testWidgets('shows check icon for all categories by default',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('shows check icon for selected category', (tester) async {
      repository.add(Category(id: '1', name: 'Electronics'));

      await tester.pumpWidget(buildTestWidget(selectedCategory: 'Electronics'));
      await tester.pump();

      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}
