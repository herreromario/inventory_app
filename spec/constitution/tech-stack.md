# Tech stack y convenciones

## Tecnologías

- **Lenguaje:** Dart 3.12+ (null safety habilitado)
- **Framework:** Flutter 3.38+ (stable channel)
- **State Management:** Riverpod 2.6+ con StateNotifier + StateNotifierProvider
- **Base de datos:** Hive CE 2.19+ (almacenamiento local NoSQL, Community Edition)
- **Routing:** GoRouter 17.3+ (ShellRoute para navegación por tabs)
- **Generación de código:** build_runner + hive_ce_generator
- **Tests:** flutter_test (unit + widget tests)
- **Linting:** flutter_lints 6.0+ (reglas estándar de Flutter)
- **Despliegue:** Solo local (emulador/dispositivo para demos)

## Archivos / módulos clave

- `lib/main.dart` — Punto de entrada, inicialización Hive y ProviderScope.
- `lib/app.dart` — MaterialApp, tema y configuración GoRouter.
- `lib/core/` — Constantes, temas y configuración global.
- `lib/features/inventory/` — Módulo principal de inventario.
- `lib/shared/widgets/` — Widgets compartidos entre features.
- `test/` — Tests unitarios y de widget (estructura espejo de lib/).

## Comandos

- `flutter run` — Arranca la app en emulador/dispositivo.
- `flutter test` — Ejecuta todos los unit y widget tests.
- `flutter analyze` — Revisa el código con reglas de lint.
- `dart run build_runner build --delete-conflicting-outputs` — Genera .g.dart.
- `dart run build_runner watch` — Generación en modo watch.
- `flutter build apk --release` — Compila para Android.
- `flutter build ios --release` — Compila para iOS.

## Modelo de datos / dominio

- **Product**
  - `id` (String, UUID v4) — Identificador único, generado automáticamente.
  - `name` (String, requerido) — Nombre del producto.
  - `description` (String?, opcional) — Descripción detallada.
  - `quantity` (int, requerido) — Cantidad actual en stock.
  - `price` (double, requerido) — Precio unitario.
  - `category` (String, requerido) — Categoría del producto.
  - `sku` (String?, opcional) — Código de barras o SKU.
  - `minStock` (int, requerido) — Stock mínimo para alertas.
  - `createdAt` (DateTime) — Fecha de creación.
  - `updatedAt` (DateTime) — Fecha de última modificación.

- **StockMovement**
  - `id` (String, UUID v4) — Identificador único.
  - `productId` (String, requerido) — Referencia al producto.
  - `type` (MovementType enum) — `entry` o `exit`.
  - `quantity` (int, requerido) — Cantidad movida.
  - `reason` (String, requerido) — Motivo del movimiento.
  - `date` (DateTime) — Fecha/hora del movimiento.

- **MovementType** (enum)
  - `entry` — Entrada de stock.
  - `exit` — Salida de stock.

## Convenciones

- Archivos: `snake_case.dart` (ej. `product_repository.dart`).
- Clases: `UpperCamelCase` (ej. `ProductRepository`).
- Variables/funciones: `lowerCamelCase` (ej. `getProducts`).
- Constantes de clase: `lowerCamelCase` (ej. `typeId`).
- Named parameters: siempre con `required` explícito.
- Modelos Hive: anotaciones `@HiveType(typeId: N)` y `@HiveField(N)`.
- Providers: exponer solo lo necesario, evitar `ref.read()` innecesarios.
- Widget trees: extraer widgets complejos en componentes separados.
- Imports: usar `package:` imports (nunca relativos).

## Estilo visual

- **Sistema de color:** Material 3 con tema personalizado (colores a definir).
- **Tipografía:** Tipografía estándar de Material 3.
- **Layout:** Diseño responsive, enfoque en móvil (portrait).

## Límites duros

- No instalar dependencias nuevas sin aprobación y justificación.
- No usar `print()` o `debugPrint()` para logging en producción.
- No subir archivos `.env`, `.env.*` o secrets al repositorio.
- No modificar archivos `.g.dart` generados — siempre usar `build_runner`.
- No usar `dynamic` o `var` cuando el tipo no sea obvio.
- No crear widgets gigantes (>200 líneas) — extraer componentes.
- No hardcodear strings de UI — preparar para futura localización.
- No saltar la validación de null checks en datos de Hive.
- No hacer commits sin que `flutter analyze` pase sin errores.
- No usar `setState` en widgets que deberían usar Riverpod.
- No usar imports relativos — usar `package:` imports.
