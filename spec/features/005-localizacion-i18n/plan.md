# 005 · Localización (i18n) — Plan

## Enfoque

Usar `flutter gen-l10n` (generador oficial de Flutter) con archivos ARB para
extraer todos los strings de UI a archivos de traducción. La app detecta
automáticamente el idioma del dispositivo usando `localeResolutionCallback`
en `MaterialApp`. No hay persistencia de preferencia ni selector manual.

## Implementación

1. Agregar dependencias en `pubspec.yaml`: `flutter_localizations` (SDK), `intl`
2. Agregar `generate: true` bajo `flutter:` en `pubspec.yaml`
3. Crear `l10n.yaml` en la raíz del proyecto con configuración de gen-l10n
4. Crear `lib/l10n/app_en.arb` — todos los strings en inglés (clave principal)
5. Crear `lib/l10n/app_es.arb` — todos los strings en español
6. Ejecutar `flutter gen-l10n` para generar `app_localizations.dart`
7. Configurar `app.dart`:
   - Importar `flutter_localizations` y `app_localizations.dart`
   - Agregar `localizationsDelegates` (Material + Widget + AppLocalizations)
   - Agregar `supportedLocales` ([Locale('en'), Locale('es')])
   - Agregar `localeResolutionCallback` con fallback a inglés
8. Reemplazar strings en `lib/shared/widgets/`:
   - `scaffold_shell.dart` — 3 labels de navegación
   - `empty_state.dart` — 1 string default
   - `confirm_dialog.dart` — 2 strings (Delete/Cancel)
9. Reemplazar strings en `lib/features/inventory/presentation/pages/`:
   - `inventory_page.dart` — 4 strings
   - `add_product_page.dart` — ~12 strings
   - `product_detail_page.dart` — ~20 strings
   - `add_movement_page.dart` — ~12 strings
   - `movement_history_page.dart` — 3 strings
   - `stats_page.dart` — 6 strings
   - `category_page.dart` — ~8 strings
   - `category_value_page.dart` — 1 string (`"Qty:"`)
10. Reemplazar strings en `lib/features/inventory/presentation/widgets/`:
    - `product_card.dart` — 3 strings (`"Sin categoría"`, `"Qty:"`, `"$"`)
    - `movement_card.dart` — 3 strings (`"Entry"`, `"Exit"`, `"Qty:"`)
    - `category_picker.dart` — 1 string
    - `category_chart.dart` — 3 strings (`"$"` en 2 formatos de eje)
    - `recent_movements.dart` — 4 strings (`"Entrada"`, `"Salida"`, `"Qty:"`, `"Producto desconocido"`)
    - `stats_empty_view.dart` — 5 strings
11. Reemplazar strings en archivos de soporte:
    - `date_group_helper.dart` — 3 strings
    - `stats_providers.dart` — 2 strings fallback
12. Reemplazar símbolo de moneda (`$` → localizado) en páginas:
    - `add_product_page.dart` — `prefixText: '\$ '`
    - `product_detail_page.dart` — `'\$${price}'` y `prefixText: '\$ '`
    - `stats_page.dart` — `'\$${stats.totalValue}'`
    - `category_value_page.dart` — 4 ocurrencias de `'\$${value}'`
13. Ejecutar `flutter analyze` y `flutter test` para verificar

## Convenciones de localización

- **Moneda**: `$` (inglés) / `€` (español) — usar key `currencySymbol` en ARB.
- **Cantidad**: `Qty` (inglés) / `Cant` (español) — usar key `quantityAbbreviation` en ARB.
- **Formato de precio**: `\$12.50` (inglés) / `12,50 €` (español) — Notación Europea con espacio antes del símbolo.

## Decisiones

- **gen-l10n sobre intl manual** — Genera código type-safe, es el estándar oficial
  y evita errores de runtime por keys inexistentes.
- **Detección automática sin persistencia** — Simplifica la implementación;
  el usuario siempre ve su idioma de sistema. Futura feature puede agregar selector.
- **Inglés como idioma principal (ARB root)** — convención estándar; el archivo
  `app_en.arb` define las keys y `app_es.arb` las traduce.
- **Strings con parámetros** — Usar `intl` syntax (`{variable}`) para strings
  dinámicos como `"Are you sure you want to delete \"{name}\"?"`.

## Riesgos

- **Olvidar strings** — Si algún string queda hardcodeado, no se verá traducido.
  Mitigación: `flutter analyze` con regla `untranslated_messages` o revisión manual.
- **Traducciones incorrectas** — Mitigación: revisar que los ARB en español
  sean naturalmente correctos, no traducciones literales del inglés.
- **Archivos .g.dart** — `gen-l10n` genera `app_localizations.dart` y `.arb`
  files. No conflicta con los `.g.dart` de Hive/build_runner.
