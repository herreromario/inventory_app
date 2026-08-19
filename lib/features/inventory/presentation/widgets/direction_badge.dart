import 'package:flutter/material.dart';
import 'package:inventory_app/core/theme/app_colors.dart';
import 'package:inventory_app/l10n/app_localizations.dart';

class DirectionBadge extends StatelessWidget {
  final bool isEntry;

  const DirectionBadge({
    super.key,
    required this.isEntry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final label = isEntry ? l10n.entry : l10n.exit;
    final color = isEntry ? AppColors.success : AppColors.danger;
    final bgColor = isEntry ? AppColors.successBackground : AppColors.dangerBackground;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isEntry ? Icons.arrow_downward : Icons.arrow_upward,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
