# Inventory App — Control de Inventario de Productos

Aplicación móvil de control de inventario para portafolio profesional.
Permite gestionar productos (CRUD), registrar movimientos de entrada/salida
y visualizar estadísticas de stock. Diseñada para demostrar buenas
prácticas de arquitectura Flutter a futuros clientes.

## Stack

- Lenguaje: Dart 3.12+ (null safety habilitado)
- Framework: Flutter 3.38+ (stable channel)
- State Management: Riverpod 2.6+ con StateNotifier + StateNotifierProvider
- Base de datos: Hive CE 2.19+ (almacenamiento local NoSQL, Community Edition)
- Routing: GoRouter 17.3+ (ShellRoute para navegación por tabs)
- Generación de código: build_runner + hive_ce_generator
- Tests: flutter_test (unit + widget tests)
- Linting: flutter_lints 6.0+ (reglas estándar de Flutter)

## Comandos

- `flutter run` — arranca la app en un emulador o dispositivo conectado
- `flutter test` — ejecuta todos los unit y widget tests
- `flutter analyze` — revisa el código con las reglas de lint
- `dart run build_runner build --delete-conflicting-outputs` — genera archivos .g.dart
- `dart run build_runner watch` — genera en modo watch durante desarrollo
- `flutter build apk --release` — compila para Android (producción)
- `flutter build ios --release` — compila para iOS (producción)

## Estructura del proyecto

- `lib/` — código fuente principal de la aplicación
  - `main.dart` — punto de entrada, inicialización de Hive y ProviderScope
  - `app.dart` — configuración de MaterialApp, tema y GoRouter
  - `hive_registrar.g.dart` — registro generado de adapters Hive (no editar)
  - `core/` — constantes, temas y configuración global
    - `constants/app_constants.dart` — rutas y valores constantes
    - `theme/app_colors.dart` — paleta de colores de la app
    - `theme/app_theme.dart` — configuración de ThemeData
  - `features/` — módulos por funcionalidad
    - `inventory/` — módulo de inventario
      - `data/models/` — modelos de datos con anotaciones @HiveType
      - `data/repositories/` — capa de acceso a datos (Hive box)
      - `presentation/pages/` — pantallas de la aplicación
      - `presentation/widgets/` — componentes UI reutilizables del módulo
      - `providers/` — Riverpod providers y StateNotifiers
  - `shared/widgets/` — widgets compartidos entre features
- `test/` — tests unitarios y de widget
  - `features/inventory/` — tests del módulo de inventario
    - `data/repositories/` — tests del repositorio
    - `providers/` — tests de providers y StateNotifiers
    - `presentation/pages/` — widget tests de pantallas
    - `presentation/widgets/` — widget tests de componentes
- `spec/` — documentación SDD (Spec-Driven Development)
  - `constitution/` — reglas estables del proyecto (mission, tech-stack, roadmap)
  - `features/` — specs por feature (spec.md, plan.md, tasks.md)
- `AGENTS.md` — este archivo
- `README.md` — documentación general del proyecto
- `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/` — proyectos plataforma
- `pubspec.yaml` — dependencias y configuración del proyecto
- `analysis_options.yaml` — reglas de linting
- `opencode.json` — configuración del agente de IA

## Convenciones

- Archivos: `snake_case.dart` (ej. `product_repository.dart`)
- Clases: `UpperCamelCase` (ej. `ProductRepository`, `InventoryNotifier`)
- Variables y funciones: `lowerCamelCase` (ej. `getProducts`, `addProduct`)
- Constantes de clase: `lowerCamelCase` (ej. `typeId`)
- Named parameters: siempre con `required` explícito para parámetros obligatorios
- Modelos Hive: anotaciones `@HiveType(typeId: N)` y `@HiveField(N)` en cada campo
- Providers: exponer solo lo necesario, evitar `ref.read()` innecesarios
- Widget trees: extraer widgets complejos en componentes separados
- Imports: usar `package:` imports (nunca imports relativos)

## Tests

- Framework: `flutter_test` (SDK)
- Estructura: replicar la estructura de `lib/` dentro de `test/`
  - `lib/features/inventory/data/repositories/product_repository.dart`
    → `test/features/inventory/data/repositories/product_repository_test.dart`
  - `lib/features/inventory/providers/inventory_providers.dart`
    → `test/features/inventory/providers/inventory_providers_test.dart`
- Unit tests: para lógica de negocio (providers, repositories, modelos)
- Widget tests: para componentes UI y pantallas
- Patrón AAA: Arrange (preparar), Act (actuar), Assert (verificar)
- Cada test debe ser independiente y no depender de otros tests
- Mockear dependencias externas (Hive box) con mocks manuales o mockito

## No hagas

- No instalar dependencias nuevas sin previa aprobación y justificación
- No usar `print()` o `debugPrint()` para logging — usar un logger apropiado
- No subir archivos `.env`, `.env.*` o secrets al repositorio
- No modificar archivos `.g.dart` generados — siempre usar `build_runner`
- No usar `dynamic` o `var` cuando el tipo no sea obvio — ser explícito
- No crear widgets gigantes (>200 líneas) — extraer componentes
- No hardcodear strings de UI — preparar para futura localización
- No saltar la validación de null checks en datos de Hive
- No hacer commits sin que `flutter analyze` pase sin errores
- No usar `setState` en widgets que deberían usar Riverpod
- No usar imports relativos — usar `package:` imports
- No omitir `required` en named parameters obligatorios
- No crear providers globales sin dependencias claras

## Flujo de trabajo

### Metodología: Spec-Driven Development (SDD)

Este proyecto usa desarrollo dirigido por especificación. La documentación
vive en `spec/` y sigue esta estructura:

```
spec/
├── constitution/            ← reglas estables del proyecto
│   ├── mission.md           ← qué construimos y para quién
│   ├── tech-stack.md        ← tecnologías, convenciones y límites
│   └── roadmap.md           ← orden y estado de las features
└── features/                ← una carpeta por feature
    └── NNN-nombre-feature/
        ├── spec.md          ← qué hace + criterios de aceptación
        ├── plan.md          ← cómo se implementa
        └── tasks.md         ← checklist de tareas
```

### Flujo para una feature nueva

1. Crear `spec/features/NNN-nombre-feature/` con el siguiente número libre
2. Escribir `spec.md`: qué hace, por qué y criterios de aceptación medibles
3. Escribir `plan.md`: enfoque técnico y decisiones, respetando `constitution/tech-stack.md`
4. Desglosar en `tasks.md` y marcar el progreso
5. Implementar y validar (`flutter analyze` + `flutter test` + build si aplica)
6. Actualizar `spec/constitution/roadmap.md` (mover la feature a "Hecho")

> **La constitución manda:** si una feature choca con `mission.md` o
> `tech-stack.md`, se replantea la feature, no la constitución.

### Reglas de ejecución

- Antes de una tarea no trivial, proponer un plan y esperar OK del usuario
- Una tarea a la vez; al terminar, reportar qué cambió para que lo revise
- Si no estás seguro al 80%, preguntar. No inventar
- Ejecutar `flutter analyze` antes de cada commit
- Ejecutar `flutter test` antes de cada commit (cuando existan tests)
- Ejecutar `dart run build_runner build --delete-conflicting-outputs` si se modifican modelos Hive
- Mantener la estructura de carpetas consistente con la arquitectura existente

## Documentación

- Effective Dart: https://dart.dev/effective-dart
- Flutter style guide: https://docs.flutter.dev/reference/flutter-cli
- Riverpod docs: https://riverpod.dev/
- Hive CE docs: https://docs.hivedb.dev/
- GoRouter docs: https://pub.dev/packages/go_router
