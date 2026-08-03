import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:inventory_app/features/inventory/data/models/stock_movement.dart';
import 'package:inventory_app/features/inventory/data/repositories/movement_repository.dart';

void main() {
  late Box box;
  late MovementRepository repository;

  setUpAll(() async {
    Hive.init('.');
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(StockMovementAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(MovementTypeAdapter());
    }
  });

  setUp(() async {
    box = await Hive.openBox('testMovementRepoBox');
    repository = MovementRepository(box);
  });

  tearDown(() async {
    await box.clear();
    await box.close();
  });

  StockMovement createMovement({
    String id = 'test-movement-id',
    String productId = 'product-1',
    MovementType type = MovementType.entry,
    int quantity = 10,
    String reason = 'Restock',
  }) {
    return StockMovement(
      id: id,
      productId: productId,
      type: type,
      quantity: quantity,
      reason: reason,
    );
  }

  group('MovementRepository', () {
    test('getMovements returns empty list initially', () {
      final movements = repository.getMovements();
      expect(movements, isEmpty);
    });

    test('add stores a movement', () {
      final movement = createMovement();
      repository.add(movement);

      final movements = repository.getMovements();
      expect(movements, hasLength(1));
      expect(movements.first.reason, equals('Restock'));
    });

    test('getById returns movement when found', () {
      final movement = createMovement(id: 'find-me');
      repository.add(movement);

      final found = repository.getById('find-me');
      expect(found, isNotNull);
      expect(found!.id, equals('find-me'));
    });

    test('getById returns null when not found', () {
      final found = repository.getById('nonexistent');
      expect(found, isNull);
    });

    test('getByProductId returns movements for specific product', () {
      repository.add(createMovement(id: 'm1', productId: 'p1'));
      repository.add(createMovement(id: 'm2', productId: 'p2'));
      repository.add(createMovement(id: 'm3', productId: 'p1'));

      final results = repository.getByProductId('p1');
      expect(results, hasLength(2));
    });

    test('getByProductId returns empty list when no matches', () {
      repository.add(createMovement(id: 'm1', productId: 'p1'));

      final results = repository.getByProductId('nonexistent');
      expect(results, isEmpty);
    });

    test('delete removes movement by id', () {
      repository.add(createMovement(id: 'delete-me'));
      expect(repository.getMovements(), hasLength(1));

      repository.delete('delete-me');
      expect(repository.getMovements(), isEmpty);
    });

    test('add multiple movements', () {
      repository.add(createMovement(id: 'm1'));
      repository.add(createMovement(id: 'm2'));
      repository.add(createMovement(id: 'm3'));

      expect(repository.getMovements(), hasLength(3));
    });
  });
}
