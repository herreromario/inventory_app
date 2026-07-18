import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_app/core/constants/app_constants.dart';
import 'package:inventory_app/core/theme/app_theme.dart';
import 'package:inventory_app/features/inventory/presentation/pages/add_product_page.dart';
import 'package:inventory_app/features/inventory/presentation/pages/category_page.dart';
import 'package:inventory_app/features/inventory/presentation/pages/inventory_page.dart';
import 'package:inventory_app/features/inventory/presentation/pages/product_detail_page.dart';
import 'package:inventory_app/features/inventory/presentation/pages/stats_page.dart';
import 'package:inventory_app/shared/widgets/scaffold_shell.dart';

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) => ScaffoldShell(child: child),
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const InventoryPage(),
        ),
        GoRoute(
          path: AppRoutes.stats,
          builder: (context, state) => const StatsPage(),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.addProduct,
      builder: (context, state) => const AddProductPage(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) => const ProductDetailPage(),
    ),
    GoRoute(
      path: AppRoutes.categories,
      builder: (context, state) => const CategoryPage(),
    ),
  ],
);

class InventoryApp extends StatelessWidget {
  const InventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Inventory App',
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}
