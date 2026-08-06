import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_app/features/inventory/providers/category_providers.dart';

class CategoryPickerPage extends ConsumerWidget {
  final String? selectedCategory;

  const CategoryPickerPage({super.key, this.selectedCategory});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Category')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('All categories'),
            trailing: selectedCategory == null || selectedCategory!.isEmpty
                ? const Icon(Icons.check)
                : null,
            onTap: () {
              context.pop('');
            },
          ),
          for (final category in categories)
            ListTile(
              title: Text(category.name),
              trailing: selectedCategory == category.name
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                context.pop(category.name);
              },
            ),
        ],
      ),
    );
  }
}
