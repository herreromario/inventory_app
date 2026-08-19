import 'package:flutter/material.dart';
import 'package:inventory_app/core/theme/app_colors.dart';
import 'package:inventory_app/core/utils/currency_formatter.dart';
import 'package:inventory_app/features/inventory/data/models/product.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/stock_indicator.dart';
import 'package:inventory_app/l10n/app_localizations.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final VoidCallback? onMovement;

  const ProductCard({
    super.key,
    required this.product,
    this.onDelete,
    this.onTap,
    this.onMovement,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasActions = onDelete != null || onMovement != null;

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
              child: StockIndicator(
                quantity: product.quantity,
                minStock: product.minStock,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${product.category ?? l10n.noCategory} · ${l10n.quantityAbbreviation}: ${product.quantity}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatCurrency(context, product.price),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.accent,
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

    if (!hasActions) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: GestureDetector(onTap: onTap, child: card),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Dismissible(
        key: ValueKey(product.id),
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 24),
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: onMovement != null
              ? const Icon(Icons.swap_horiz, color: AppColors.onPrimary)
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
              onMovement != null) {
            onMovement!.call();
          }
          return false;
        },
        child: GestureDetector(onTap: onTap, child: card),
      ),
    );
  }
}
