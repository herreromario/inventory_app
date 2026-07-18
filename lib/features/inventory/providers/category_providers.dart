import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:inventory_app/features/inventory/data/models/category.dart';
import 'package:inventory_app/features/inventory/data/repositories/category_repository.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final box = Hive.box('inventoryBox');
  return CategoryRepository(box);
});

final categoryProvider =
    StateNotifierProvider<CategoryNotifier, List<Category>>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return CategoryNotifier(repository);
});

class CategoryNotifier extends StateNotifier<List<Category>> {
  final CategoryRepository _repository;

  CategoryNotifier(this._repository) : super([]) {
    _loadCategories();
  }

  void _loadCategories() {
    state = _repository.getCategories();
  }

  Category? getCategoryById(String id) {
    try {
      return state.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  void addCategory({required String name}) {
    final category = Category(
      id: _uuid.v4(),
      name: name,
    );
    state = [...state, category];
    _repository.add(category);
  }

  void updateCategory(String id, String newName) {
    final category = getCategoryById(id);
    if (category == null) return;

    final updated = Category(
      id: category.id,
      name: newName,
      createdAt: category.createdAt,
    );
    state = [
      for (final c in state)
        if (c.id == id) updated else c,
    ];
    _repository.update(updated);
  }

  void deleteCategory(String id) {
    state = [
      for (final c in state)
        if (c.id != id) c,
    ];
    _repository.delete(id);
  }
}
