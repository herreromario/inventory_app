# 001 · Gestión de productos — Plan

## Enfoque

Implementar el módulo completo de inventario siguiendo la arquitectura
feature-based existente: data/models → data/repositories → providers →
presentation/widgets → presentation/pages. Usar Hive CE para persistencia
local y Riverpod StateNotifier para estado.

## Implementación

1. Crear modelo `Product` con anotaciones `@HiveType` — `lib/features/inventory/data/models/product.dart`
2. Generar adapter con `build_runner` — archivo `product.g.dart`
3. Implementar `ProductRepository` con CRUD contra Hive box — `lib/features/inventory/data/repositories/product_repository.dart`
4. Crear `InventoryNotifier` (StateNotifier) y providers — `lib/features/inventory/providers/inventory_providers.dart`
5. Crear widget `ProductCard` para la lista — `lib/features/inventory/presentation/widgets/product_card.dart`
6. Crear widget `StockIndicator` (punto de color) — `lib/features/inventory/presentation/widgets/stock_indicator.dart`
7. Crear `AddProductPage` (formulario) — `lib/features/inventory/presentation/pages/add_product_page.dart`
8. Crear `ProductDetailPage` (detalle/edición) — `lib/features/inventory/presentation/pages/product_detail_page.dart`
9. Crear `InventoryPage` (lista principal) — `lib/features/inventory/presentation/pages/inventory_page.dart`
10. Configurar rutas en `app.dart` con GoRouter
11. Implementar widget `EmptyState` — `lib/shared/widgets/empty_state.dart`
12. Crear tests unitarios para repository y providers
13. Crear widget tests para pages principales

## Decisiones

- **StateNotifier sobre Notifier** — Patrón establecido en el proyecto, documentado en AGENTS.md.
- **Hive box única para productos** — Simplifica persistencia, un solo box 'inventoryBox'.
- **UUID v4 para IDs** — Generados con paquete `uuid`, garantiza unicidad sin coordination.
- **Stock con 3 niveles** — Verde (>minStock), amarillo (igual a minStock), rojo (<minStock).

## Riesgos

- **Generación de adapters Hive** — Requiere `build_runner` y puede fallar con cambios en el modelo. Mitigación: ejecutar `build_runner build --delete-conflicting-outputs` tras cada cambio.
- **Rendimiento con muchos productos** — Hive carga todo en memoria. Mitigación: para un demo con cientos de productos es aceptable.
