import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_app/core/constants/app_constants.dart';
import 'package:inventory_app/features/inventory/providers/filter_providers.dart';
import 'package:inventory_app/l10n/app_localizations.dart';

class FilterPage extends ConsumerStatefulWidget {
  const FilterPage({super.key});

  @override
  ConsumerState<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends ConsumerState<FilterPage> {
  late FilterDraft _draft;

  @override
  void initState() {
    super.initState();
    final notifier = ref.read(filterProvider.notifier);
    notifier.initDraft();
    _draft = notifier.draft!.copy();
  }

  String _stockStatusLabel(StockStatus status, AppLocalizations l10n) {
    switch (status) {
      case StockStatus.all:
        return l10n.all;
      case StockStatus.low:
        return l10n.low;
      case StockStatus.normal:
        return l10n.normal;
      case StockStatus.high:
        return l10n.high;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentFilter = ref.watch(filterProvider);
    final hasChanges = _draft.hasChanges(currentFilter);
    final activeCount = _draft.activeCount;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.filters),
        actions: [
          if (activeCount > 0)
            TextButton(
              onPressed: () {
                setState(() {
                  _draft = FilterDraft();
                });
              },
              child: Text(l10n.clear),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text(l10n.categoryLabel),
                  subtitle: Text(
                    _draft.selectedCategory ?? l10n.allCategories,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final result = await context.push<String>(
                      AppRoutes.categoryPicker,
                      extra: _draft.selectedCategory,
                    );
                    if (result != null && mounted) {
                      setState(() {
                        _draft.selectedCategory = result.isEmpty ? null : result;
                      });
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text(l10n.stockStatus),
                  subtitle: Text(_stockStatusLabel(_draft.stockStatus, l10n)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showStockStatusPicker();
                  },
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: hasChanges ? _applyFilters : null,
                  child: Text(_buttonLabel(hasChanges, activeCount, l10n)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _buttonLabel(bool hasChanges, int activeCount, AppLocalizations l10n) {
    if (!hasChanges) return l10n.showResults;
    if (activeCount > 0) return l10n.showResultsCount(activeCount);
    return l10n.clearFilters;
  }

  void _showStockStatusPicker() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.stockStatus,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              for (final status in StockStatus.values)
                ListTile(
                  title: Text(_stockStatusLabel(status, l10n)),
                  trailing: _draft.stockStatus == status
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () {
                    setState(() {
                      _draft.stockStatus = status;
                    });
                    Navigator.of(context).pop();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _applyFilters() {
    final notifier = ref.read(filterProvider.notifier);
    notifier.stageCategory(_draft.selectedCategory);
    notifier.stageStockStatus(_draft.stockStatus);
    notifier.applyDraft();
    if (mounted) {
      context.pop();
    }
  }
}
