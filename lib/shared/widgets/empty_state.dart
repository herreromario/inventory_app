import 'package:flutter/material.dart';
import 'package:inventory_app/l10n/app_localizations.dart';

class EmptyState extends StatelessWidget {
  final String? messageKey;
  final String? message;
  final IconData icon;

  const EmptyState({
    super.key,
    this.messageKey,
    this.message,
    this.icon = Icons.inventory_2_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
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
