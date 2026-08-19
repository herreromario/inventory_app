# Patrón de diseño — App de Inventario

Documento autocontenido: no depende de ningún archivo de tema existente en el proyecto. Todos los valores están definidos aquí directamente. Cuando se implemente la spec, estos valores son los que deben materializarse en el sistema de tema de la app (existente o nuevo).

## Colores

| Nombre | Valor | Uso |
|---|---|---|
| Acento | `#185FA5` | Acción primaria (FAB), precios/valores monetarios, elemento activo de navegación, enlaces |
| Éxito | `#3B6D11` | Estado positivo (stock ok), entradas de movimiento |
| Éxito (fondo) | `#EAF3DE` | Fondo de badges de estado positivo/entrada |
| Peligro | `#A32D2D` | Estado negativo (stock bajo), salidas de movimiento, acción destructiva |
| Peligro (fondo) | `#FCEBEB` | Fondo de badges de estado negativo/salida |
| Texto primario | `#1A1A18` | Títulos, texto de item |
| Texto secundario | `#5F5E5A` | Metadatos (categoría, cantidad) |
| Texto muted | `#888780` | Hints, labels pequeños, iconos inactivos |
| Fondo de página | `#FAFAF8` | Fondo general de pantalla |
| Fondo de tarjeta | `#F1EFE8` | Fondo de tarjeta base (chips, stat cards) |
| Fondo de tarjeta elevada | `#FFFFFF` | Fondo de tarjeta de item (lista) |
| Borde | `#000000` al 12% opacidad | Borde hairline de tarjetas (0.5px) |

**Regla de color**: un color = un significado. Éxito/Peligro solo para estado de stock y dirección de movimiento. Acento solo para acción primaria, valores monetarios y navegación activa. No reutilizar un color con un sentido distinto al definido aquí.

## Radios y espaciado

- Radio de tarjeta: `12px`
- Radio de chip: `16px`
- Sistema de espaciado (único permitido): `4 / 8 / 16 / 24 / 32 px`

## Tipografía

- Título de pantalla: 22–24px, peso 500
- Texto de item: 15–16px, peso 500
- Metadatos: 12–13px, peso 400, color texto secundario
- Valores destacados (precios): 14–16px, peso 500, color acento
- Sentence case siempre, nunca mayúsculas completas
- Truncado con ellipsis, nunca corte abrupto de texto

## Componentes

**Tarjeta de item**: fondo blanco (fondo de tarjeta elevada), borde hairline 12% negro a 0.5px, radio 12px, padding 12px. Barra de estado a la izquierda (ver abajo). Título en 1 línea con ellipsis, metadatos debajo, valor destacado en color acento. Sin iconos de acción visibles por defecto — nunca sombra marcada ni gradiente.

**Barra de estado**: rectángulo vertical de 6px de ancho, radio 3px, alto ajustado al contenido de la tarjeta (~36-44px), pegado al borde izquierdo de la tarjeta de item. Color éxito o peligro según el significado de la fila (estado de stock, o dirección del movimiento).

**Swipe actions**: las acciones secundarias de una tarjeta (traspaso/editar, eliminar) no se muestran de forma permanente — se revelan al deslizar la tarjeta hacia la izquierda, ocupando el alto completo de la fila. Color acento para traspaso/editar, color peligro para eliminar.

**Badge de dirección**: pill (radio total) con icono + texto corto, fondo y color de peligro para salida, fondo y color de éxito para entrada.

**Chip**: fondo de tarjeta base, borde hairline, radio de chip (16px), icono + texto 13px en color texto secundario. Visualmente distinto de un campo de búsqueda.

**Tarjeta de métrica**: fondo de tarjeta base, radio de tarjeta (12px), icono 18px arriba (color según significado: neutro, éxito para dinero, peligro para alerta, acento para actividad), valor grande 22px/peso 500 debajo, etiqueta pequeña (12px, texto muted) al final.

**Navegación inferior**: icono + etiqueta 11px. Ítem activo en color acento, inactivos en texto muted.

## Reglas generales

- Toda tarjeta lleva fondo + borde + radio — nunca solo una línea divisoria suelta como separador.
- Diseño plano: sin gradientes ni sombras pronunciadas.
- Espaciado siempre del sistema de 8px, sin valores intermedios sueltos.
- Acciones secundarias de fila siempre ocultas tras swipe, nunca expuestas de forma permanente.
