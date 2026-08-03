import 'package:hive_ce/hive.dart';

part 'stock_movement.g.dart';

@HiveType(typeId: 3)
enum MovementType {
  @HiveField(0)
  entry,

  @HiveField(1)
  exit,
}

@HiveType(typeId: 2)
class StockMovement {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productId;

  @HiveField(2)
  final MovementType type;

  @HiveField(3)
  final int quantity;

  @HiveField(4)
  final String reason;

  @HiveField(5)
  final DateTime date;

  StockMovement({
    required this.id,
    required this.productId,
    required this.type,
    required this.quantity,
    required this.reason,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  StockMovement copyWith({
    MovementType? type,
    int? quantity,
    String? reason,
  }) {
    return StockMovement(
      id: id,
      productId: productId,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      reason: reason ?? this.reason,
      date: date,
    );
  }
}
