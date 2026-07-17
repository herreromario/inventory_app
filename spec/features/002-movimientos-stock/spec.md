# 002 · Movimientos de stock

**Estado:** propuesta

## Qué hace

El usuario puede registrar entradas y salidas de stock para cada producto.
Cada movimiento se guarda con tipo (entrada/salida), cantidad, motivo,
fecha/hora y referencia al producto. Se muestra un historial de movimientos
por producto y global.

## Por qué

Sin control de movimientos no se puede saber de dónde viene el stock actual.
El historial permite auditar cambios y detectar patrones de uso.

## Criterios de aceptación

- [ ] Se puede registrar una entrada de stock (cantidad, motivo).
- [ ] Se puede registrar una salida de stock (cantidad, motivo).
- [ ] La cantidad del producto se actualiza automáticamente al registrar un movimiento.
- [ ] No se permite salida de más stock del disponible.
- [ ] Se muestra historial de movimientos por producto.
- [ ] Se muestra historial global de movimientos.
- [ ] Cada movimiento muestra fecha/hora, tipo y motivo.
- [ ] Los datos persisten tras cerrar y reabrir la app.
- [ ] `flutter analyze` pasa sin errores.
- [ ] Todos los tests pasan.

## Fuera de alcance

- Estadísticas de movimientos (feature 003).
- Búsqueda/filtrado de movimientos (feature 004).
- Exportación de datos.
