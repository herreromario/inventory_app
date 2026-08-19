import 'package:flutter/material.dart';
import 'package:inventory_app/core/theme/app_colors.dart';
import 'package:inventory_app/l10n/app_localizations.dart';

class EmptyState extends StatelessWidget {
  final String? message;
  final IconData icon;

  const EmptyState({
    super.key,
    this.message,
    this.icon = Icons.inventory_2_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.textMuted),
          const SizedBox(height: 16),
          Text(
            message ?? AppLocalizations.of(context)!.noItemsFound,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
