import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_app/core/theme/app_colors.dart';
import 'package:inventory_app/features/inventory/providers/category_providers.dart';
import 'package:inventory_app/l10n/app_localizations.dart';
import 'package:inventory_app/shared/widgets/confirm_dialog.dart';
import 'package:inventory_app/shared/widgets/empty_state.dart';

class CategoryPage extends ConsumerWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider);
    final l10n = AppLocalizations.of(context)!;
    final sorted = List.of(categories)
      ..sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.categories)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: sorted.isEmpty
          ? EmptyState(
              message: l10n.noCategoriesYet,
              icon: Icons.category_outlined,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: sorted.length,
              separatorBuilder: (_, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final category = sorted[index];
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardBackgroundElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border, width: 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cardShadow,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => context.pop(category.name),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.label,
                              color: AppColors.textMuted,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                category.name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              color: AppColors.textMuted,
                              onPressed: () => _showEditDialog(
                                  context, ref, category.id, category.name),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20),
                              color: AppColors.textMuted,
                              onPressed: () async {
                                final confirmed = await ConfirmDialog.show(
                                  context: context,
                                  title: l10n.deleteCategory,
                                  message: l10n.confirmDeleteCategory(
                                      category.name),
                                );
                                if (confirmed && context.mounted) {
                                  ref
                                      .read(categoryProvider.notifier)
                                      .deleteCategory(category.id);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.newCategory),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.categoryNameLabel,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                ref.read(categoryProvider.notifier).addCategory(name: name);
                Navigator.of(context).pop();
              }
            },
            child: Text(l10n.create),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, WidgetRef ref, String id, String currentName) {
    final controller = TextEditingController(text: currentName);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editCategory),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.categoryNameLabel,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                ref
                    .read(categoryProvider.notifier)
                    .updateCategory(id, name);
                Navigator.of(context).pop();
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
