import 'package:hive_ce/hive.dart';
import 'package:inventory_app/features/inventory/data/models/stock_movement.dart';

class MovementRepository {
  final Box _box;
  static const String _key = 'MOVEMENTS_LIST';

  MovementRepository(this._box);

  List<StockMovement> getMovements() {
    return List<StockMovement>.from(_box.get(_key) ?? []);
  }

  StockMovement? getById(String id) {
    final movements = getMovements();
    try {
      return movements.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  List<StockMovement> getByProductId(String productId) {
    return getMovements().where((m) => m.productId == productId).toList();
  }

  void add(StockMovement movement) {
    final movements = getMovements();
    movements.add(movement);
    _save(movements);
  }

  void update(StockMovement updated) {
    final movements = getMovements();
    final index = movements.indexWhere((m) => m.id == updated.id);
    if (index != -1) {
      movements[index] = updated;
      _save(movements);
    }
  }

  void delete(String id) {
    final movements = getMovements();
    movements.removeWhere((m) => m.id == id);
    _save(movements);
  }

  void _save(List<StockMovement> movements) {
    _box.put(_key, movements);
  }
}
