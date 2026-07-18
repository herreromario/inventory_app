import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:inventory_app/features/inventory/data/models/category.dart';
import 'package:inventory_app/features/inventory/data/repositories/category_repository.dart';

void main() {
  late Box box;
  late CategoryRepository repository;

  setUpAll(() async {
    Hive.init('.');
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CategoryAdapter());
    }
  });

  setUp(() async {
    box = await Hive.openBox('testCategoryRepoBox');
    repository = CategoryRepository(box);
  });

  tearDown(() async {
    await box.clear();
    await box.close();
  });

  Category createCategory({
    String id = 'test-id',
    String name = 'Test Category',
  }) {
    return Category(id: id, name: name);
  }

  group('CategoryRepository', () {
    test('getCategories returns empty list initially', () {
      final categories = repository.getCategories();
      expect(categories, isEmpty);
    });

    test('add stores a category', () {
      final category = createCategory();
      repository.add(category);

      final categories = repository.getCategories();
      expect(categories, hasLength(1));
      expect(categories.first.name, equals('Test Category'));
    });

    test('getById returns category when found', () {
      final category = createCategory(id: 'find-me');
      repository.add(category);

      final found = repository.getById('find-me');
      expect(found, isNotNull);
      expect(found!.id, equals('find-me'));
    });

    test('getById returns null when not found', () {
      final found = repository.getById('nonexistent');
      expect(found, isNull);
    });

    test('update modifies existing category', () {
      final category = createCategory(id: 'update-me');
      repository.add(category);

      final updated = Category(id: 'update-me', name: 'Updated Name');
      repository.update(updated);

      final categories = repository.getCategories();
      expect(categories.first.name, equals('Updated Name'));
    });

    test('delete removes category by id', () {
      final category = createCategory(id: 'delete-me');
      repository.add(category);
      expect(repository.getCategories(), hasLength(1));

      repository.delete('delete-me');
      expect(repository.getCategories(), isEmpty);
    });
  });
}
