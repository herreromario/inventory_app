# 002 · Movimientos de stock — Plan

## Enfoque

Extender el módulo existente con un nuevo modelo `StockMovement` y su
repository. Crear un notifier separado para movimientos. La UI incluirá
un formulario de registro y pantallas de historial.

## Implementación

1. Crear enum `MovementType` (entry/exit) — `lib/features/inventory/data/models/stock_movement.dart`
2. Crear modelo `StockMovement` con anotaciones @HiveType — mismo archivo
3. Ejecutar build_runner para generar adapters
4. Implementar `MovementRepository` con persistencia en Hive — `lib/features/inventory/data/repositories/movement_repository.dart`
5. Crear `MovementNotifier` y providers — `lib/features/inventory/providers/movement_providers.dart`
6. Crear widget `MovementCard` — `lib/features/inventory/presentation/widgets/movement_card.dart`
7. Crear `AddMovementPage` (formulario) — `lib/features/inventory/presentation/pages/add_movement_page.dart`
8. Crear `MovementHistoryPage` (historial) — `lib/features/inventory/presentation/pages/movement_history_page.dart`
9. Actualizar `InventoryPage` para botón de agregar movimiento por producto
10. Actualizar `ProductDetailPage` con historial de movimientos del producto
11. Crear tests unitarios y widget tests
12. Validar regla: no salida de más stock del disponible

## Decisiones

- **Repository separado** — `MovementRepository` independiente de `ProductRepository` para separación de responsabilidades.
- **Validación en el notifier** — La regla "no salida > stock disponible" se valida en el StateNotifier antes de persistir.
- **Movimientos en box separada** — Usar box 'movementsBox' para aislar datos de movimientos.

## Riesgos

- **Consistencia entre boxes** — Si falla la escritura de movimientos, el stock del producto queda desactualizado. Mitigación: transacciones Hive (si están disponibles) o validación post-escritura.
