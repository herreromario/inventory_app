# 001 · Gestión de productos

**Estado:** propuesta

## Qué hace

El usuario puede agregar, editar, listar y eliminar productos del inventario.
Cada producto tiene nombre, descripción, cantidad, precio, categoría, SKU
y stock mínimo. La lista muestra todos los productos con indicador de stock.

## Por qué

Es la feature fundacional: sin productos no hay inventario. Establece la
arquitectura base (models, repositories, providers, UI) que las demás
features reutilizarán.

## Criterios de aceptación

- [ ] Se puede agregar un producto con todos los campos requeridos.
- [ ] Se puede editar cualquier campo de un producto existente.
- [ ] Se puede eliminar un producto con confirmación.
- [ ] La lista muestra todos los productos ordenados por fecha de creación.
- [ ] Cada producto muestra indicador de stock (verde/amarillo/rojo).
- [ ] Se muestra estado vacío cuando no hay productos.
- [ ] Los datos persisten tras cerrar y reabrir la app (Hive).
- [ ] `flutter analyze` pasa sin errores.
- [ ] Todos los tests pasan.

## Fuera de alcance

- Movimientos de stock (feature 002).
- Búsqueda y filtrado (feature 004).
- Estadísticas (feature 003).
