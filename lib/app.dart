import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_app/core/constants/app_constants.dart';
import 'package:inventory_app/features/inventory/presentation/pages/add_product_page.dart';
import 'package:inventory_app/features/inventory/presentation/pages/inventory_page.dart';
import 'package:inventory_app/features/inventory/presentation/pages/product_detail_page.dart';
import 'package:inventory_app/features/inventory/presentation/pages/stats_page.dart';
import 'package:inventory_app/shared/widgets/scaffold_shell.dart';

// Configuración del enrutador GoRouter
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    // ShellRoute: contenedor con NavigationBar para rutas hijas
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
    // Rutas fuera del shell: se apilan encima sin NavigationBar
    GoRoute(
      path: AppRoutes.addProduct,
      builder: (context, state) => const AddProductPage(),
    ),
    GoRoute(
      path: AppRoutes.productDetail('id'),
      builder: (context, state) => const ProductDetailPage(),
    ),
  ],
);
class InventoryApp extends StatelessWidget {
  const InventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router);
  }
}