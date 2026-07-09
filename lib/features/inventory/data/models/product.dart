import 'package:hive_ce/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class Product {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? description;
  @HiveField(3)
  final int quantity;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.quantity,
  });
}
