# 004 · Búsqueda y filtrado

**Estado:** hecho

## Qué hace

El usuario puede buscar productos por nombre, filtrar por categoría,
filtrar por estado de stock (bajo, normal, alto) y ordenar por diferentes
campos (nombre, cantidad, precio, fecha).

Los filtros se configuran en una pantalla dedicada y se aplican con
el botón "Mostrar resultados". La ordenación se realiza desde un
menú inferior que se aplica inmediatamente.

## Por qué

Con muchos productos, encontrar uno específico sin búsqueda es tedioso.
El filtrado permite vistas rápidas del estado del inventario.

## Criterios de aceptación

- [x] Barra de búsqueda filtra por nombre en tiempo real.
- [x] Botón "Filtros" abre pantalla dedicada de configuración.
- [x] Filtro por categoría (pantalla de selección).
- [x] Filtro por estado de stock (bajo/normal/alto).
- [x] Los filtros se combinan (categoría + estado).
- [x] Los filtros NO se aplican inmediatamente (borrador).
- [x] Botón "Mostrar resultados" aplica todos los filtros.
- [x] Botón "Ordenar" abre menú inferior con opciones.
- [x] Ordenamiento por nombre, cantidad, precio, fecha.
- [x] Se muestra estado vacío cuando no hay resultados.
- [x] Botón "Clear" para resetear filtros en pantalla dedicada.
- [x] `flutter analyze` pasa sin errores.
- [x] Todos los tests pasan.

## Fuera de alcance

- Búsqueda en movimientos.
- Guardado de filtros favoritos.
- Búsqueda por código/SKU.
