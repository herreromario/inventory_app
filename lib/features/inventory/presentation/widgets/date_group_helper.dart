import 'package:inventory_app/features/inventory/data/models/stock_movement.dart';
import 'package:inventory_app/l10n/app_localizations.dart';

class DateGroup {
  final String label;
  final List<StockMovement> movements;

  DateGroup({required this.label, required this.movements});
}

List<DateGroup> groupMovementsByDate(
    List<StockMovement> movements, AppLocalizations l10n) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final twoDaysAgo = today.subtract(const Duration(days: 2));

  final Map<String, List<StockMovement>> groups = {};

  for (final m in movements) {
    final date = DateTime(m.date.year, m.date.month, m.date.day);
    String key;

    if (!date.isBefore(today)) {
      key = l10n.today;
    } else if (!date.isBefore(yesterday)) {
      key = l10n.yesterday;
    } else if (date.isAfter(twoDaysAgo)) {
      final diff = today.difference(date).inDays;
      key = l10n.daysAgo(diff);
    } else {
      key =
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }

    groups.putIfAbsent(key, () => []);
    groups[key]!.add(m);
  }

  final result = <DateGroup>[];
  for (final entry in groups.entries) {
    result.add(DateGroup(label: entry.key, movements: entry.value));
  }
  return result;
}
