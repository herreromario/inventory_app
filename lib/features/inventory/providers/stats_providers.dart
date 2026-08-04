import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/features/inventory/data/models/product.dart';
import 'package:inventory_app/features/inventory/data/models/stock_movement.dart';
import 'package:inventory_app/features/inventory/providers/inventory_providers.dart';
import 'package:inventory_app/features/inventory/providers/movement_providers.dart';

class InventoryStats {
  final int totalProducts;
  final double totalValue;
  final int lowStockCount;
  final List<StockMovement> recentMovements;
  final Map<String, double> valueByCategory;

  const InventoryStats({
    required this.totalProducts,
    required this.totalValue,
    required this.lowStockCount,
    required this.recentMovements,
    required this.valueByCategory,
  });

  bool get isEmpty => totalProducts == 0;

  List<MapEntry<String, double>> get topCategories {
    final sorted = valueByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted;
  }
}

String getProductName(List<Product> products, String productId) {
  try {
    return products.firstWhere((p) => p.id == productId).name;
  } catch (_) {
    return 'Producto desconocido';
  }
}

final statsProvider = Provider<InventoryStats>((ref) {
  final products = ref.watch(inventoryProvider);
  final movements = ref.watch(movementProvider);

  final totalProducts = products.length;

  final totalValue = products.fold<double>(
    0,
    (sum, p) => sum + (p.quantity * p.price),
  );

  final lowStockCount = products.where((p) => p.quantity <= p.minStock).length;

  final sortedMovements = List<StockMovement>.from(movements)
    ..sort((a, b) => b.date.compareTo(a.date));
  final recentMovements = sortedMovements.take(5).toList();

  final valueByCategory = <String, double>{};
  for (final product in products) {
    final category = product.category ?? 'Sin categoría';
    final value = product.quantity * product.price;
    valueByCategory[category] = (valueByCategory[category] ?? 0) + value;
  }

  return InventoryStats(
    totalProducts: totalProducts,
    totalValue: totalValue,
    lowStockCount: lowStockCount,
    recentMovements: recentMovements,
    valueByCategory: valueByCategory,
  );
});
