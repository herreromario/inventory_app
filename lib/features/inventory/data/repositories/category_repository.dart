import 'package:hive_ce/hive.dart';
import 'package:inventory_app/features/inventory/data/models/category.dart';

class CategoryRepository {
  final Box _box;
  static const String _key = 'CATEGORIES_LIST';

  CategoryRepository(this._box);

  List<Category> getCategories() {
    return List<Category>.from(_box.get(_key) ?? []);
  }

  Category? getById(String id) {
    final categories = getCategories();
    try {
      return categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  void add(Category category) {
    final categories = getCategories();
    categories.add(category);
    _save(categories);
  }

  void update(Category updated) {
    final categories = getCategories();
    final index = categories.indexWhere((c) => c.id == updated.id);
    if (index != -1) {
      categories[index] = updated;
      _save(categories);
    }
  }

  void delete(String id) {
    final categories = getCategories();
    categories.removeWhere((c) => c.id == id);
    _save(categories);
  }

  void _save(List<Category> categories) {
    _box.put(_key, categories);
  }
}
