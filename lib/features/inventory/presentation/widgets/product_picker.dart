import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_app/core/constants/app_constants.dart';
import 'package:inventory_app/core/theme/app_colors.dart';
import 'package:inventory_app/features/inventory/providers/inventory_providers.dart';
import 'package:inventory_app/l10n/app_localizations.dart';

class ProductPicker extends ConsumerWidget {
  final String? selectedProductId;
  final ValueChanged<String?> onSelected;

  const ProductPicker({
    super.key,
    this.selectedProductId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final products = ref.watch(inventoryProvider);
    final product = selectedProductId != null
        ? products.where((p) => p.id == selectedProductId).firstOrNull
        : null;

    return InkWell(
      onTap: () async {
        final result = await context.push<String>(AppRoutes.productPicker);
        if (result != null) {
          onSelected(result);
        }
      },
      child: product != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.cardBackgroundElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          l10n.currentStock(product.quantity),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear, size: 20, color: AppColors.textMuted),
                    onPressed: () => onSelected(null),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.textMuted),
                ],
              ),
            )
          : InputDecorator(
              decoration: InputDecoration(
                labelText: l10n.productLabel,
                suffixIcon: const Icon(Icons.chevron_right, color: AppColors.textMuted),
              ),
              child: Text(
                l10n.selectProduct,
                style: const TextStyle(color: AppColors.textMuted),
              ),
            ),
    );
  }
}
