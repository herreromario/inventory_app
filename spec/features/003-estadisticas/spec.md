# 003 · Estadísticas

**Estado:** completada

## Qué hace

Dashboard que muestra métricas clave del inventario: total de productos,
valor total del inventario, productos con stock bajo, movimientos recientes
y gráfico de las 3 categorías con mayor valor. Incluye página de detalle
"Valor por categoría" con tarjetas expandibles.

## Por qué

Dar una visión rápida del estado del inventario. Sin esto, el usuario
debe recorrer toda la lista para entender la situación.

## Criterios de aceptación

- [x] Se muestra total de productos en inventario.
- [x] Se muestra valor total del inventario (suma de cantidad × precio).
- [x] Se muestra cantidad de productos con stock bajo.
- [x] Se muestra lista de últimos 5 movimientos.
- [x] Se muestra gráfico de barras de las 3 categorías con mayor valor.
- [x] Los valores se formatean como moneda ($XX,XXX.XX).
- [x] TextButton "Ver todas las categorías" aparece si hay >3 categorías.
- [x] Página "Valor por categoría" con total general, valor y porcentaje.
- [x] Tarjetas expandibles muestran top 3 productos por categoría.
- [x] Los datos se actualizan al volver a la pantalla.
- [x] Se muestra estado vacío cuando no hay datos.
- [x] `flutter analyze` pasa sin errores.
- [x] Todos los tests pasan.

## Fuera de alcance

- Exportación de reportes.
- Gráficos históricos (solo snapshot actual).
- Filtros de fecha en estadísticas.
