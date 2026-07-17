# 003 · Estadísticas — Plan

## Enfoque

Crear un provider derivado que calcule las métricas a partir de los datos
existentes (products + movements). Usar un widget de gráficos ligero o
implementar barras simples con widgets Flutter nativos.

## Implementación

1. Crear `StatsProvider` (Provider derivado) — `lib/features/inventory/providers/stats_providers.dart`
2. Calcular: total productos, valor total, stock bajo, movimientos recientes
3. Crear `StatsCard` widget — `lib/features/inventory/presentation/widgets/stats_card.dart`
4. Crear `CategoryChart` widget (barras simples) — `lib/features/inventory/presentation/widgets/category_chart.dart`
5. Crear `RecentMovements` widget — `lib/features/inventory/presentation/widgets/recent_movements.dart`
6. Crear `StatsPage` — `lib/features/inventory/presentation/pages/stats_page.dart`
7. Integrar en GoRouter con tab de navegación
8. Crear tests unitarios para StatsProvider
9. Crear widget tests para StatsPage

## Decisiones

- **Provider derivado sin estado propio** — Las estadísticas se calculan de products + movements, no necesitan persistencia separada.
- **Gráficos con widgets nativos** — Evitar dependencia externa (fl_chart, etc.). Barras simples con Container + FractionallySizedBox.
- **Solo 5 movimientos recientes** — Evitar listas largas innecesarias en dashboard.

## Riesgos

- **Rendimiento del cálculo** — Con muchos productos podría ser lento. Mitigación: caching con StateProvider o memoización.
