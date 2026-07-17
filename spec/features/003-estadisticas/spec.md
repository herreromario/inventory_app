# 003 · Estadísticas

**Estado:** propuesta

## Qué hace

Dashboard que muestra métricas clave del inventario: total de productos,
valor total del inventario, productos con stock bajo, movimientos recientes
y gráfico de distribución por categorías.

## Por qué

Dar una visión rápida del estado del inventario. Sin esto, el usuario
debe recorrer toda la lista para entender la situación.

## Criterios de aceptación

- [ ] Se muestra total de productos en inventario.
- [ ] Se muestra valor total del inventario (suma de cantidad × precio).
- [ ] Se muestra cantidad de productos con stock bajo.
- [ ] Se muestra lista de últimos 5 movimientos.
- [ ] Se muestra gráfico de barras de productos por categoría.
- [ ] Los datos se actualizan al volver a la pantalla.
- [ ] Se muestra estado vacío cuando no hay datos.
- [ ] `flutter analyze` pasa sin errores.
- [ ] Todos los tests pasan.

## Fuera de alcance

- Exportación de reportes.
- Gráficos históricos (solo snapshot actual).
- Filtros de fecha en estadísticas.
