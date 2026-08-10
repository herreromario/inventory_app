import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
          : ListView.builder(
              itemCount: sorted.length,
              itemBuilder: (context, index) {
                final category = sorted[index];
                return ListTile(
                  title: Text(category.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () =>
                            _showEditDialog(context, ref, category.id, category.name),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final confirmed = await ConfirmDialog.show(
                            context: context,
                            title: l10n.deleteCategory,
                            message: l10n.confirmDeleteCategory(category.name),
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
                  onTap: () => context.pop(category.name),
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
            border: const OutlineInputBorder(),
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
            border: const OutlineInputBorder(),
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
