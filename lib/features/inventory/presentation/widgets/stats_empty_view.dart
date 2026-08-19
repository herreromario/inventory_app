import 'package:flutter/material.dart';
import 'package:inventory_app/core/theme/app_colors.dart';
import 'package:inventory_app/l10n/app_localizations.dart';

class StatsEmptyView extends StatelessWidget {
  const StatsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bar_chart,
                size: 64,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noDataToShow,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.addProductsAndViewStats,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            _FeatureHighlight(
              icon: Icons.add_shopping_cart,
              label: l10n.registerProducts,
            ),
            const SizedBox(height: 12),
            _FeatureHighlight(
              icon: Icons.swap_horiz,
              label: l10n.controlEntryExit,
            ),
            const SizedBox(height: 12),
            _FeatureHighlight(
              icon: Icons.insights,
              label: l10n.viewKeyMetrics,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureHighlight extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureHighlight({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: AppColors.accent),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
