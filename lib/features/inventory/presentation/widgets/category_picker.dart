import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_app/core/constants/app_constants.dart';
import 'package:inventory_app/core/theme/app_colors.dart';
import 'package:inventory_app/l10n/app_localizations.dart';

class CategoryPicker extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onSelected;

  const CategoryPicker({
    super.key,
    this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final hasCategory = selectedCategory?.isNotEmpty == true;
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: () async {
        final result = await context.push<String>(
          AppRoutes.categoryPicker,
          extra: selectedCategory,
        );
        if (result != null) {
          onSelected(result);
        }
      },
      child: hasCategory
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.cardBackgroundElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
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
                      selectedCategory!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
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
                labelText: l10n.categoryLabel,
                filled: true,
                fillColor: AppColors.cardBackgroundElevated,
                suffixIcon: const Icon(Icons.chevron_right, color: AppColors.textMuted),
              ),
              child: Text(
                l10n.noCategory,
                style: const TextStyle(color: AppColors.textMuted),
              ),
            ),
    );
  }
}
