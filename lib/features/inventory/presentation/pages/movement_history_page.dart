import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_app/core/constants/app_constants.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/movement_card.dart';
import 'package:inventory_app/features/inventory/providers/inventory_providers.dart';
import 'package:inventory_app/features/inventory/providers/movement_providers.dart';
import 'package:inventory_app/shared/widgets/confirm_dialog.dart';
import 'package:inventory_app/shared/widgets/empty_state.dart';

import 'package:inventory_app/features/inventory/presentation/widgets/date_group_helper.dart';

class MovementHistoryPage extends ConsumerWidget {
  const MovementHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movements = ref.watch(movementProvider);

    final sorted = List.of(movements)
      ..sort((a, b) => b.date.compareTo(a.date));

    final groups = groupMovementsByDate(sorted);

    return Scaffold(
      appBar: AppBar(title: const Text('Movement History')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addMovement),
        child: const Icon(Icons.add),
      ),
      body: sorted.isEmpty
          ? const EmptyState(message: 'No movements yet')
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
                                title: 'Delete Movement',
                                message:
                                    'Are you sure you want to delete this movement?',
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
