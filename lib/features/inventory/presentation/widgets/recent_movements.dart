import 'package:flutter/material.dart';
import 'package:inventory_app/core/theme/app_colors.dart';
import 'package:inventory_app/features/inventory/data/models/stock_movement.dart';
import 'package:inventory_app/l10n/app_localizations.dart';

class RecentMovements extends StatelessWidget {
  final List<StockMovement> movements;
  final Map<String, String> productNames;

  const RecentMovements({
    super.key,
    required this.movements,
    required this.productNames,
  });

  String _formatDate(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final movementDate = DateTime(date.year, date.month, date.day);
    final time =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    if (movementDate == today) {
      return '${l10n.today} $time';
    } else if (movementDate == today.subtract(const Duration(days: 1))) {
      return '${l10n.yesterday} $time';
    }
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} $time';
  }

  @override
  Widget build(BuildContext context) {
    if (movements.isEmpty) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.latestMovements,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: movements.length,
          separatorBuilder: (_, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final movement = movements[index];
            final isEntry = movement.type == MovementType.entry;
            final productName =
                productNames[movement.productId] ?? l10n.unknownProduct;
            final dateStr = _formatDate(movement.date, l10n);

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
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 6, top: 12, bottom: 12),
                      child: Container(
                        width: 6,
                        decoration: BoxDecoration(
                          color: isEntry
                              ? AppColors.success
                              : AppColors.danger,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(8, 12, 12, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    movement.reason,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  dateStr,
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              productName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isEntry
                                    ? AppColors.successBackground
                                    : AppColors.dangerBackground,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isEntry
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    size: 12,
                                    color: isEntry
                                        ? AppColors.success
                                        : AppColors.danger,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${isEntry ? l10n.entry : l10n.exit} · ${l10n.quantityAbbreviation}: ${movement.quantity}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isEntry
                                          ? AppColors.success
                                          : AppColors.danger,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
