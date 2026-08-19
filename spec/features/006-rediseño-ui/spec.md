# 006 · Rediseño UI — Patrón de Diseño

**Estado:** implementado

## Que hace
Cambia el diseño visual completo de la aplicación para alinearse con el
patrón de diseño definido en `patron-diseno.md`. Incluye: nueva paleta de
colores cálida/terrosa, tarjetas con barra de estado vertical y acciones
ocultas tras swipe, chips, badges de dirección, tarjetas de métrica,
navegación inferior estilizada, forms con la nueva paleta, y espaciado
estricto de 8px.

## Por que
El diseño actual usa colores Material genéricos (azul, teal, gris) que no
distinguen la app de un prototipo base. El patrón de diseño define una
identidad visual propia con significado semántico claro (éxito = stock ok,
peligro = stock bajo/salida, acento = acción primaria). Esto eleva el
nivel percibido de calidad para clientes potenciales.

## Criterios de aceptacion
- [ ] La paleta de colores `AppColors` refleja exactamente los valores de `patron-diseno.md`
- [ ] El tema `AppTheme` aplica radios 12px (tarjetas) y 16px (chips)
- [ ] Todo espaciado UI usa el sistema 4/8/16/24/32px (sin valores intermedios)
- [ ] `ProductCard` muestra barra de estado vertical de 6px a la izquierda
- [ ] `MovementCard` muestra barra de estado vertical de 6px a la izquierda
- [ ] Acciones de tarjeta (editar/eliminar) se revelan al deslizar hacia la izquierda
- [ ] `StatsCard` sigue el patrón de tarjeta de métrica (icono arriba, valor grande, label pequeño)
- [ ] Badge de dirección muestra pill con icono + texto para entrada/salida
- [ ] Navegación inferior muestra icono + etiqueta 11px, activo en color acento
- [ ] Forms usan colores del patrón (labels, hints, borders, botones)
- [ ] No existen colores hardcodeados (`Colors.green`, `Colors.red`, `Colors.grey`) en ningún widget
- [ ] `flutter analyze` pasa sin errores
- [ ] Tests existentes pasan y cubren los componentes modificados
- [ ] Sentence case en todos los textos de UI (nunca mayúsculas completas)
- [ ] Truncado con ellipsis en textos largos, sin corte abrupto

## Fuera de alcance
- Tema oscuro (solo tema claro)
- Animaciones o transiciones custom
- Cambios en la estructura de navegación (tabs se mantienen)
- Nuevos features o funcionalidad
- Cambios en modelos de datos o providers
