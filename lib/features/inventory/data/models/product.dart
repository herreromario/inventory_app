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
  @HiveField(4)
  final double price;
  @HiveField(5)
  final String? category;
  @HiveField(6)
  final String? sku;
  @HiveField(7)
  final int minStock;
  @HiveField(8)
  final DateTime createdAt;
  @HiveField(9)
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.quantity,
    required this.price,
    this.category,
    this.sku,
    required this.minStock,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Product copyWith({
    String? name,
    String? description,
    int? quantity,
    double? price,
    String? category,
    String? sku,
    int? minStock,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      category: category ?? this.category,
      sku: sku ?? this.sku,
      minStock: minStock ?? this.minStock,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
