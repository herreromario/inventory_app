# 006 · Rediseño UI — Plan

## Enfoque
Reemplazar el sistema de tema actual por la paleta del patrón de diseño,
luego actualizar cada widget/UI component para usar los nuevos colores,
estilos y estructura definidos. Se trabaja de afuera hacia adentro:
primero el tema global, luego los componentes compartidos, luego los
widgets de feature, y finalmente las pages.

## Implementacion

### Fase 1: Tema global
1. Actualizar `lib/core/theme/app_colors.dart` — nueva paleta completa
2. Actualizar `lib/core/theme/app_theme.dart` — ColorScheme, CardTheme,
   NavigationBarTheme, InputDecorationTheme, TextTheme con valores del patrón

### Fase 2: Widgets compartidos
3. Actualizar `lib/shared/widgets/scaffold_shell.dart` — navegación
   inferior con nuevo estilo (icono + label 11px, colores)
4. Actualizar `lib/shared/widgets/empty_state.dart` — colores del patrón

### Fase 3: Widgets de inventario
5. Reescribir `lib/features/inventory/presentation/widgets/product_card.dart`
   — barra de estado vertical, fondo blanco, borde hairline, swipe actions
6. Reescribir `lib/features/inventory/presentation/widgets/movement_card.dart`
   — barra de estado vertical, fondo blanco, borde hairline, swipe actions
7. Actualizar `lib/features/inventory/presentation/widgets/stock_indicator.dart`
   — convertir de círculo a barra vertical de 6px
8. Crear `lib/features/inventory/presentation/widgets/direction_badge.dart`
   — pill badge para entrada/salida
9. Actualizar `lib/features/inventory/presentation/widgets/stats_card.dart`
   — patrón de tarjeta de métrica
10. Actualizar `lib/features/inventory/presentation/widgets/recent_movements.dart`
    — nuevo estilo de tarjeta
11. Actualizar `lib/features/inventory/presentation/widgets/category_chart.dart`
    — colores del patrón
12. Actualizar `lib/features/inventory/presentation/widgets/category_picker.dart`
    — chip style según patrón
13. Actualizar `lib/features/inventory/presentation/widgets/product_picker.dart`
    — chip style según patrón

### Fase 4: Pages
14. Actualizar `lib/features/inventory/presentation/pages/inventory_page.dart`
    — colores, espaciado
15. Actualizar `lib/features/inventory/presentation/pages/movement_history_page.dart`
    — colores, espaciado
16. Actualizar `lib/features/inventory/presentation/pages/stats_page.dart`
    — colores, espaciado, layout de métricas
17. Actualizar `lib/features/inventory/presentation/pages/add_product_page.dart`
    — estilizar form
18. Actualizar `lib/features/inventory/presentation/pages/add_movement_page.dart`
    — estilizar form
19. Actualizar `lib/features/inventory/presentation/pages/product_detail_page.dart`
    — estilizar detail view
20. Actualizar pages restantes (category_page, filter_page, etc.)

### Fase 5: Limpieza
21. Eliminar todos los `Colors.green`/`Colors.red`/`Colors.grey` hardcodeados
22. Verificar que no queden imports de `AppColors` con valores obsoletos

### Fase 6: Tests y validación
23. Actualizar tests de widgets para validar nuevos estilos
24. Ejecutar `flutter analyze` — debe pasar sin errores
25. Ejecutar `flutter test` — todos deben pasar

## Decisiones
- **Adaptar componentes existentes en lugar de crear nuevos** — evita
  duplicación y mantiene la estructura de imports existente
- **Swipe actions con Dismissible** — Flutter tiene soporte nativo para
  swipe-to-dismiss, no se necesita dependencia externa
- **Barra de estado como widget separado** — reutilizable en ambas tarjetas
- **Sin tema oscuro** — el patrón solo define tema claro; se puede agregar
  en una feature futura
- **Espaciado estricto de 8px** — se usa `SizedBox` con múltiplos de 8
  en lugar de valores arbitrarios

## Riesgos
- **Swipe actions pueden romper tests existentes** — mitigación: actualizar
  tests después de cada cambio de componente
- **Hardcoded colors en múltiples archivos** — mitigación: grep exhaustivo
  de `Colors.green`, `Colors.red`, `Colors.grey` antes de cerrar la feature
- **ListTile-based cards vs card custom** — las tarjetas actuales usan
  ListTile; el patrón pide Card custom. Puede requerir reestructuración
  completa del widget
