# 004 · Búsqueda y filtrado

**Estado:** propuesta

## Qué hace

El usuario puede buscar productos por nombre, filtrar por categoría,
filtrar por estado de stock (bajo, normal, alto) y ordenar por diferentes
campos (nombre, cantidad, precio, fecha).

## Por qué

Con muchos productos, encontrar uno específico sin búsqueda es tedioso.
El filtrado permite vistas rápidas del estado del inventario.

## Criterios de aceptación

- [ ] Barra de búsqueda filtra por nombre en tiempo real.
- [ ] Filtro por categoría (select/dropdown).
- [ ] Filtro por estado de stock (bajo/normal/alto).
- [ ] Ordenamiento por nombre, cantidad, precio, fecha.
- [ ] Los filtros se combinan (búsqueda + categoría + estado).
- [ ] Se muestra estado vacío cuando no hay resultados.
- [ ] Los filtros se resetean con botón "Limpiar".
- [ ] `flutter analyze` pasa sin errores.
- [ ] Todos los tests pasan.

## Fuera de alcance

- Búsqueda en movimientos.
- Guardado de filtros favoritos.
- Búsqueda por código/SKU.
