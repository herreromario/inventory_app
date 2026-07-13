import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldShell extends StatelessWidget {
  final Widget child;

  const ScaffoldShell({super.key, required this.child});

  // Lee la URL actual y devuelve el índice del tab seleccionado
  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location == '/') return 0;
    if (location == '/stats') return 1;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
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
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}
