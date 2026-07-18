import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:inventory_app/features/inventory/data/models/category.dart';
import 'package:inventory_app/features/inventory/data/repositories/category_repository.dart';
import 'package:inventory_app/features/inventory/providers/category_providers.dart';

void main() {
  late Box box;
  late CategoryRepository repository;
  late CategoryNotifier notifier;

  setUpAll(() async {
    Hive.init('.');
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CategoryAdapter());
    }
  });

  setUp(() async {
    box = await Hive.openBox('testCategoryNotifierBox');
    repository = CategoryRepository(box);
    notifier = CategoryNotifier(repository);
  });

  tearDown(() async {
    await box.clear();
    await box.close();
  });

  group('CategoryNotifier', () {
    test('initial state is empty list', () {
      expect(notifier.state, isEmpty);
    });

    test('addCategory adds category to state', () {
      notifier.addCategory(name: 'Electronics');

      expect(notifier.state, hasLength(1));
      expect(notifier.state.first.name, equals('Electronics'));
    });

    test('addCategory generates UUID', () {
      notifier.addCategory(name: 'Test');

      final category = notifier.state.first;
      expect(category.id, isNotEmpty);
      expect(category.createdAt, isNotNull);
    });

    test('getCategoryById returns category', () {
      notifier.addCategory(name: 'Find Me');

      final id = notifier.state.first.id;
      final found = notifier.getCategoryById(id);
      expect(found, isNotNull);
      expect(found!.name, equals('Find Me'));
    });

    test('getCategoryById returns null for nonexistent id', () {
      expect(notifier.getCategoryById('nonexistent'), isNull);
    });

    test('deleteCategory removes category from state', () {
      notifier.addCategory(name: 'To Delete');

      final id = notifier.state.first.id;
      notifier.deleteCategory(id);

      expect(notifier.state, isEmpty);
    });

    test('updateCategory modifies category name in state', () {
      notifier.addCategory(name: 'Original');

      final id = notifier.state.first.id;
      notifier.updateCategory(id, 'Modified');

      expect(notifier.state.first.name, equals('Modified'));
    });

    test('addCategory persists to repository', () {
      notifier.addCategory(name: 'Persistent');

      final fromRepo = repository.getCategories();
      expect(fromRepo, hasLength(1));
      expect(fromRepo.first.name, equals('Persistent'));
    });
  });
}
