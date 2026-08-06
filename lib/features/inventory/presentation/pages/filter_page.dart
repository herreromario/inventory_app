import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_app/core/constants/app_constants.dart';
import 'package:inventory_app/features/inventory/providers/filter_providers.dart';

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

  String _stockStatusLabel(StockStatus status) {
    switch (status) {
      case StockStatus.all:
        return 'All';
      case StockStatus.low:
        return 'Low';
      case StockStatus.normal:
        return 'Normal';
      case StockStatus.high:
        return 'High';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentFilter = ref.watch(filterProvider);
    final hasChanges = _draft.hasChanges(currentFilter);
    final activeCount = _draft.activeCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        actions: [
          if (activeCount > 0)
            TextButton(
              onPressed: () {
                setState(() {
                  _draft = FilterDraft();
                });
              },
              child: const Text('Clear'),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: const Text('Category'),
                  subtitle: Text(
                    _draft.selectedCategory ?? 'All categories',
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
                  title: const Text('Stock Status'),
                  subtitle: Text(_stockStatusLabel(_draft.stockStatus)),
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
                  child: Text(_buttonLabel(hasChanges, activeCount)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _buttonLabel(bool hasChanges, int activeCount) {
    if (!hasChanges) return 'Show results';
    if (activeCount > 0) return 'Show results ($activeCount)';
    return 'Clear filters';
  }

  void _showStockStatusPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Stock Status',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              for (final status in StockStatus.values)
                ListTile(
                  title: Text(_stockStatusLabel(status)),
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
