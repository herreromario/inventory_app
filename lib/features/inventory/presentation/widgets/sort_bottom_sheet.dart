import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/core/theme/app_colors.dart';
import 'package:inventory_app/features/inventory/providers/filter_providers.dart';
import 'package:inventory_app/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.sortBy,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          for (final field in SortField.values)
            ListTile(
              title: Text(
                _sortFieldLabel(field, l10n),
                style: TextStyle(
                  color: filter.sortField == field
                      ? AppColors.accent
                      : AppColors.textPrimary,
                ),
              ),
              trailing: filter.sortField == field
                  ? Icon(
                      filter.sortAscending
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: AppColors.accent,
                      size: 20,
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

  String _sortFieldLabel(SortField field, AppLocalizations l10n) {
    switch (field) {
      case SortField.name:
        return l10n.sortName;
      case SortField.quantity:
        return l10n.sortQuantity;
      case SortField.price:
        return l10n.sortPrice;
      case SortField.createdAt:
        return l10n.sortDate;
    }
  }
}
