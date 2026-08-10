import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_app/l10n/app_localizations.dart';

class ScaffoldShell extends StatelessWidget {
  final Widget child;

  const ScaffoldShell({super.key, required this.child});

  // Lee la URL actual y devuelve el índice del tab seleccionado
  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location == '/') return 0;
    if (location == '/movement-history') return 1;
    if (location == '/stats') return 2;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/movement-history');
        break;
      case 2:
        context.go('/stats');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child, // Contenido de la ruta activa, la NavigationBar persiste
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context), // Tab activo según URL
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.inventory_2_outlined),
            selectedIcon: const Icon(Icons.inventory_2),
            label: AppLocalizations.of(context)!.navInventory,
          ),
          NavigationDestination(
            icon: const Icon(Icons.swap_horiz_outlined),
            selectedIcon: const Icon(Icons.swap_horiz),
            label: AppLocalizations.of(context)!.navMovements,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart),
            label: AppLocalizations.of(context)!.navStats,
          ),
        ],
      ),
    );
  }
}
