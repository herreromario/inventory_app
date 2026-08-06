import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/features/inventory/providers/filter_providers.dart';

class SortBottomSheet extends ConsumerWidget {
  const SortBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => const SortBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Sort by',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          for (final field in SortField.values)
            ListTile(
              title: Text(_sortFieldLabel(field)),
              trailing: filter.sortField == field
                  ? Icon(
                      filter.sortAscending
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                    )
                  : null,
              onTap: () {
                ref.read(filterProvider.notifier).setSortField(field);
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }

  String _sortFieldLabel(SortField field) {
    switch (field) {
      case SortField.name:
        return 'Name';
      case SortField.quantity:
        return 'Quantity';
      case SortField.price:
        return 'Price';
      case SortField.createdAt:
        return 'Date';
    }
  }
}
