import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/core/theme/app_colors.dart';
import 'package:inventory_app/core/utils/currency_formatter.dart';
import 'package:inventory_app/features/inventory/providers/inventory_providers.dart';
import 'package:inventory_app/features/inventory/providers/stats_providers.dart';
import 'package:inventory_app/l10n/app_localizations.dart';

class CategoryValuePage extends ConsumerStatefulWidget {
  const CategoryValuePage({super.key});

  @override
  ConsumerState<CategoryValuePage> createState() => _CategoryValuePageState();
}

class _CategoryValuePageState extends ConsumerState<CategoryValuePage> {
  int? _expandedIndex;
  final List<ExpansibleController> _controllers = [];

  void _initControllers(int count) {
    for (final c in _controllers) {
      c.dispose();
    }
    _controllers.clear();
    _expandedIndex = null;
    for (var i = 0; i < count; i++) {
      _controllers.add(ExpansibleController());
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(statsProvider);
    final products = ref.watch(inventoryProvider);
    final l10n = AppLocalizations.of(context)!;

    if (stats.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.valueByCategory),
        ),
        body: Center(
          child: Text(l10n.noDataAvailable),
        ),
      );
    }

    final totalValue = stats.totalValue;
    final sortedCategories = stats.topCategories;

    if (_controllers.length != sortedCategories.length) {
      _initControllers(sortedCategories.length);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.valueByCategory),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
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
              child: Row(
                children: [
                  const Icon(
                    Icons.attach_money,
                    color: AppColors.success,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.totalInventory,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        formatCurrency(context, totalValue),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.categoriesCount(sortedCategories.length),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sortedCategories.length,
              separatorBuilder: (_, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final entry = sortedCategories[index];
                final categoryValue = entry.value;
                final percentage = totalValue > 0
                    ? (categoryValue / totalValue * 100)
                    : 0.0;

                final categoryProducts = products
                    .where((p) =>
                        (p.category ?? l10n.noCategory) == entry.key)
                    .toList()
                  ..sort((a, b) =>
                      (b.quantity * b.price).compareTo(a.quantity * a.price));
                final top3 = categoryProducts.take(3).toList();

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cardShadow,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: AppColors.cardBackgroundElevated,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                          color: AppColors.border, width: 0.5),
                    ),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        controller: _controllers[index],
                        tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        onExpansionChanged: (expanded) {
                          if (expanded) {
                            if (_expandedIndex != null &&
                                _expandedIndex != index) {
                              _controllers[_expandedIndex!].collapse();
                            }
                            _expandedIndex = index;
                          } else if (_expandedIndex == index) {
                            _expandedIndex = null;
                          }
                        },
                        title: Text(
                          entry.key,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          '${formatCurrency(context, categoryValue)} · ${percentage.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        children: [
                          if (top3.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(l10n.noProducts),
                            )
                          else
                            ...top3.map((product) {
                              final productValue =
                                  product.quantity * product.price;
                              return ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                title: Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                subtitle: Text(
                                  '${l10n.quantityAbbreviation}: ${product.quantity} · ${formatCurrency(context, product.price)}',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                                trailing: Text(
                                  formatCurrency(context, productValue),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.accent,
                                  ),
                                ),
                              );
                            }),
                          if (categoryProducts.length > 3)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                l10n.moreProducts(categoryProducts.length - 3),
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
