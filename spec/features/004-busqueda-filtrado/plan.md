# 004 · Búsqueda y filtrado — Plan

## Enfoque

Implementar un provider que mantenga el estado de los filtros y derive
la lista filtrada. La UI incluirá barra de búsqueda y chips/dropdowns
para filtros. El filtrado se hace en memoria sobre la lista de productos.

## Implementación

1. Crear `FilterState` y `FilterNotifier` — `lib/features/inventory/providers/filter_providers.dart`
2. Crear provider derivado `filteredProducts` — mismo archivo
3. Crear widget `SearchBar` — `lib/features/inventory/presentation/widgets/search_bar.dart`
4. Crear widget `FilterChips` — `lib/features/inventory/presentation/widgets/filter_chips.dart`
5. Crear widget `SortSelector` — `lib/features/inventory/presentation/widgets/sort_selector.dart`
6. Actualizar `InventoryPage` para integrar filtros
7. Crear tests unitarios para FilterNotifier
8. Crear widget tests para componentes de filtro

## Decisiones

- **Filtrado en memoria** — Los filtros se aplican sobre la lista ya cargada de Hive. No hay consultas complejas.
- **Provider separado** — `FilterState` es independiente de `InventoryNotifier` para separación de responsabilidades.
- **Chips para filtros** — UX más visual que dropdowns, Material 3 guidelines.

## Riesgos

- **Rendimiento con muchos filtros** — Con cientos de productos el filtrado en memoria es aceptable. Para miles se necesitaría índices en Hive.
