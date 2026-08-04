import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_app/core/constants/app_constants.dart';
import 'package:inventory_app/core/theme/app_colors.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/category_chart.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/recent_movements.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/stats_card.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/stats_empty_view.dart';
import 'package:inventory_app/features/inventory/providers/inventory_providers.dart';
import 'package:inventory_app/features/inventory/providers/stats_providers.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);
    final products = ref.watch(inventoryProvider);

    if (stats.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
        ),
        body: const StatsEmptyView(),
      );
    }

    final productNames = <String, String>{};
    for (final product in products) {
      productNames[product.id] = product.name;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resumen del inventario',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  StatsCard(
                    icon: Icons.inventory_2,
                    value: stats.totalProducts.toString(),
                    label: 'Total productos',
                    iconColor: AppColors.primary,
                  ),
                  StatsCard(
                    icon: Icons.attach_money,
                    value: '\$${stats.totalValue.toStringAsFixed(2)}',
                    label: 'Valor total',
                    iconColor: AppColors.stockGreen,
                  ),
                  StatsCard(
                    icon: Icons.warning_amber,
                    value: stats.lowStockCount.toString(),
                    label: 'Stock bajo',
                    iconColor: AppColors.stockRed,
                  ),
                  StatsCard(
                    icon: Icons.swap_horiz,
                    value: stats.recentMovements.length.toString(),
                    label: 'Movimientos recientes',
                    iconColor: AppColors.secondary,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (stats.valueByCategory.isNotEmpty) ...[
                CategoryChart(data: stats.valueByCategory),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        context.push(AppRoutes.categoryValue),
                    child: const Text('Ver todas las categorías →'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (stats.recentMovements.isNotEmpty)
                RecentMovements(
                  movements: stats.recentMovements,
                  productNames: productNames,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
