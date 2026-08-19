import 'package:flutter/material.dart';
import 'package:inventory_app/core/theme/app_colors.dart';
import 'package:inventory_app/features/inventory/data/models/stock_movement.dart';
import 'package:inventory_app/l10n/app_localizations.dart';

class MovementCard extends StatelessWidget {
  final StockMovement movement;
  final String? productName;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final EdgeInsetsGeometry? margin;

  const MovementCard({
    super.key,
    required this.movement,
    this.productName,
    this.onDelete,
    this.onEdit,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isEntry = movement.type == MovementType.entry;
    final l10n = AppLocalizations.of(context)!;
    final hasActions = onDelete != null || onEdit != null;

    final card = Container(
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
              padding: const EdgeInsets.only(left: 6, top: 12, bottom: 12),
              child: Container(
                width: 6,
                decoration: BoxDecoration(
                  color: isEntry ? AppColors.success : AppColors.danger,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movement.reason,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (productName != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        productName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isEntry ? AppColors.successBackground : AppColors.dangerBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isEntry ? Icons.arrow_downward : Icons.arrow_upward,
                            size: 12,
                            color: isEntry ? AppColors.success : AppColors.danger,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${isEntry ? l10n.entry : l10n.exit} · ${l10n.quantityAbbreviation}: ${movement.quantity}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isEntry ? AppColors.success : AppColors.danger,
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

    final effectiveMargin = margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 4);

    if (!hasActions) {
      return Padding(
        padding: effectiveMargin,
        child: card,
      );
    }

    return Padding(
      padding: effectiveMargin,
      child: Dismissible(
        key: ValueKey(movement.id),
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 24),
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: onEdit != null
              ? const Icon(Icons.edit, color: AppColors.onPrimary)
              : const SizedBox.shrink(),
        ),
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
            color: AppColors.danger,
            borderRadius: BorderRadius.circular(12),
          ),
          child: onDelete != null
              ? const Icon(Icons.delete, color: AppColors.onPrimary)
              : const SizedBox.shrink(),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart && onDelete != null) {
            onDelete!.call();
          } else if (direction == DismissDirection.startToEnd &&
              onEdit != null) {
            onEdit!.call();
          }
          return false;
        },
        child: card,
      ),
    );
  }
}
