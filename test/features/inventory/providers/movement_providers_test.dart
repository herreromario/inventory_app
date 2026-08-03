import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:inventory_app/features/inventory/data/models/product.dart';
import 'package:inventory_app/features/inventory/data/models/stock_movement.dart';
import 'package:inventory_app/features/inventory/data/repositories/movement_repository.dart';
import 'package:inventory_app/features/inventory/data/repositories/product_repository.dart';
import 'package:inventory_app/features/inventory/providers/inventory_providers.dart';
import 'package:inventory_app/features/inventory/providers/movement_providers.dart';

void main() {
  late Box box;
  late ProductRepository productRepository;
  late MovementRepository movementRepository;
  late InventoryNotifier inventoryNotifier;
  late MovementNotifier movementNotifier;

  setUpAll(() async {
    Hive.init('.');
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProductAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(StockMovementAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(MovementTypeAdapter());
    }
  });

  setUp(() async {
    box = await Hive.openBox('testMovementNotifierBox');
    productRepository = ProductRepository(box);
    movementRepository = MovementRepository(box);
    inventoryNotifier = InventoryNotifier(productRepository);
    movementNotifier = MovementNotifier(movementRepository, inventoryNotifier);
  });

  tearDown(() async {
    await box.clear();
    await box.close();
  });

  group('MovementNotifier', () {
    test('initial state is empty list', () {
      expect(movementNotifier.state, isEmpty);
    });

    test('addMovement entry creates movement and updates product stock', () {
      inventoryNotifier.addProduct(
        name: 'Test Product',
        quantity: 10,
        price: 9.99,
        category: 'Test',
        minStock: 5,
      );
      final productId = inventoryNotifier.state.first.id;

      movementNotifier.addMovement(
        productId: productId,
        type: MovementType.entry,
        quantity: 5,
        reason: 'Restock',
      );

      expect(movementNotifier.state, hasLength(1));
      expect(movementNotifier.state.first.type, equals(MovementType.entry));
      expect(movementNotifier.state.first.quantity, equals(5));

      final product = inventoryNotifier.getProductById(productId);
      expect(product!.quantity, equals(15));
    });

    test('addMovement exit decreases product stock', () {
      inventoryNotifier.addProduct(
        name: 'Test Product',
        quantity: 10,
        price: 9.99,
        category: 'Test',
        minStock: 5,
      );
      final productId = inventoryNotifier.state.first.id;

      movementNotifier.addMovement(
        productId: productId,
        type: MovementType.exit,
        quantity: 3,
        reason: 'Sold',
      );

      expect(movementNotifier.state, hasLength(1));
      final product = inventoryNotifier.getProductById(productId);
      expect(product!.quantity, equals(7));
    });

    test('addMovement exit throws when quantity exceeds stock', () {
      inventoryNotifier.addProduct(
        name: 'Test Product',
        quantity: 5,
        price: 9.99,
        category: 'Test',
        minStock: 1,
      );
      final productId = inventoryNotifier.state.first.id;

      expect(
        () => movementNotifier.addMovement(
          productId: productId,
          type: MovementType.exit,
          quantity: 10,
          reason: 'Too much',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('getMovementsByProduct returns movements for specific product', () {
      inventoryNotifier.addProduct(
        name: 'Product A',
        quantity: 10,
        price: 9.99,
        category: 'Test',
        minStock: 5,
      );
      inventoryNotifier.addProduct(
        name: 'Product B',
        quantity: 20,
        price: 19.99,
        category: 'Test',
        minStock: 5,
      );

      final pA = inventoryNotifier.state[0].id;
      final pB = inventoryNotifier.state[1].id;

      movementNotifier.addMovement(
        productId: pA,
        type: MovementType.entry,
        quantity: 5,
        reason: 'Restock A',
      );
      movementNotifier.addMovement(
        productId: pB,
        type: MovementType.entry,
        quantity: 10,
        reason: 'Restock B',
      );
      movementNotifier.addMovement(
        productId: pA,
        type: MovementType.exit,
        quantity: 2,
        reason: 'Sold A',
      );

      final movementsA = movementNotifier.getMovementsByProduct(pA);
      expect(movementsA, hasLength(2));

      final movementsB = movementNotifier.getMovementsByProduct(pB);
      expect(movementsB, hasLength(1));
    });

    test('addMovement generates UUID and timestamp', () {
      inventoryNotifier.addProduct(
        name: 'Test Product',
        quantity: 10,
        price: 9.99,
        category: 'Test',
        minStock: 5,
      );
      final productId = inventoryNotifier.state.first.id;

      movementNotifier.addMovement(
        productId: productId,
        type: MovementType.entry,
        quantity: 5,
        reason: 'Restock',
      );

      final movement = movementNotifier.state.first;
      expect(movement.id, isNotEmpty);
      expect(movement.date, isNotNull);
    });

    test('deleteMovement removes movement from state', () {
      inventoryNotifier.addProduct(
        name: 'Test Product',
        quantity: 10,
        price: 9.99,
        category: 'Test',
        minStock: 5,
      );
      final productId = inventoryNotifier.state.first.id;

      movementNotifier.addMovement(
        productId: productId,
        type: MovementType.entry,
        quantity: 5,
        reason: 'Restock',
      );

      final movementId = movementNotifier.state.first.id;
      movementNotifier.deleteMovement(movementId);

      expect(movementNotifier.state, isEmpty);
    });
  });
}
