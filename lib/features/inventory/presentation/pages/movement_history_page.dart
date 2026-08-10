import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_app/core/constants/app_constants.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/movement_card.dart';
import 'package:inventory_app/features/inventory/providers/inventory_providers.dart';
import 'package:inventory_app/features/inventory/providers/movement_providers.dart';
import 'package:inventory_app/l10n/app_localizations.dart';
import 'package:inventory_app/shared/widgets/confirm_dialog.dart';
import 'package:inventory_app/shared/widgets/empty_state.dart';

import 'package:inventory_app/features/inventory/presentation/widgets/date_group_helper.dart';

class MovementHistoryPage extends ConsumerWidget {
  const MovementHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movements = ref.watch(movementProvider);
    final l10n = AppLocalizations.of(context)!;

    final sorted = List.of(movements)
      ..sort((a, b) => b.date.compareTo(a.date));

    final groups = groupMovementsByDate(sorted, l10n);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.movementHistory)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addMovement),
        child: const Icon(Icons.add),
      ),
      body: sorted.isEmpty
          ? EmptyState(message: l10n.noMovementsYet)
          : ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        group.label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ...group.movements.map((m) {
                          final product = ref
                              .read(inventoryProvider.notifier)
                              .getProductById(m.productId);
                          return MovementCard(
                            movement: m,
                            productName: product?.name,
                            onEdit: () {
                              context.push(
                                '${AppRoutes.addMovement}?movementId=${m.id}',
                              );
                            },
                            onDelete: () async {
                              final confirmed = await ConfirmDialog.show(
                                context: context,
                                title: l10n.deleteMovement,
                                message: l10n.confirmDeleteMovement,
                              );
                              if (confirmed && context.mounted) {
                                ref
                                    .read(movementProvider.notifier)
                                    .deleteMovement(m.id);
                              }
                            },
                          );
                        }),
                  ],
                );
              },
            ),
    );
  }
}
