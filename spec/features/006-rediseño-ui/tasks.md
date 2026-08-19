# 006 · Rediseño UI — Tareas

## Tema global
- [x] Actualizar `lib/core/theme/app_colors.dart` con paleta de patron-diseno.md
- [x] Actualizar `lib/core/theme/app_theme.dart` con ColorScheme, CardTheme, NavigationBarTheme, TextTheme

## Widgets compartidos
- [x] Actualizar `lib/shared/widgets/scaffold_shell.dart` — navegación inferior estilo patrón
- [x] Actualizar `lib/shared/widgets/empty_state.dart` — colores del patrón

## Widgets de inventario
- [x] Reescribir `product_card.dart` — barra de estado vertical, borde hairline, swipe actions
- [x] Reescribir `movement_card.dart` — barra de estado vertical, borde hairline, swipe actions
- [x] Actualizar `stock_indicator.dart` — barra vertical de 6px
- [x] Crear `direction_badge.dart` — pill badge entrada/salida
- [x] Actualizar `stats_card.dart` — patrón tarjeta de métrica
- [x] Actualizar `recent_movements.dart` — nuevo estilo
- [x] Actualizar `category_chart.dart` — colores del patrón
- [x] Actualizar `category_picker.dart` — chip style
- [x] Actualizar `product_picker.dart` — chip style

## Pages
- [x] Actualizar `inventory_page.dart`
- [x] Actualizar `movement_history_page.dart`
- [x] Actualizar `stats_page.dart`
- [x] Actualizar `add_product_page.dart` — form styling
- [x] Actualizar `add_movement_page.dart` — form styling
- [x] Actualizar `product_detail_page.dart`
- [x] Actualizar `category_page.dart`
- [x] Actualizar `filter_page.dart`
- [x] Actualizar `category_value_page.dart`
- [x] Actualizar `category_picker_page.dart`
- [x] Actualizar `product_picker_page.dart`

## Limpieza
- [x] Eliminar todos los `Colors.green` hardcodeados
- [x] Eliminar todos los `Colors.red` hardcodeados
- [x] Eliminar todos los `Colors.grey` hardcodeados
- [x] Verificar imports de AppColors actualizados

## Tests y validacion
- [x] Actualizar tests de `product_card_test.dart`
- [x] Actualizar tests de `movement_card_test.dart`
- [x] Actualizar tests de `stats_card_test.dart`
- [x] Crear tests de `direction_badge_test.dart`
- [x] Ejecutar `flutter analyze` — sin errores
- [x] Ejecutar `flutter test` — todos pasan
- [x] Validar contra los criterios de aceptacion de spec.md
- [x] Mover la feature a "Hecho" en ../../constitution/roadmap.md
