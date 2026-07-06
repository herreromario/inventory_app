import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_app/core/constants/app_constants.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.push(AppRoutes.addProduct),
              child: const Text('Add Product'),
            ),
            ElevatedButton(
              onPressed: () => context.push(AppRoutes.stats),
              child: const Text('View Stats'),
            ),
          ],
        ),
      )
    );
  }
}