import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_app/features/inventory/providers/filter_providers.dart';

void main() {
  late FilterNotifier notifier;

  setUp(() {
    notifier = FilterNotifier();
  });

  group('FilterNotifier', () {
    test('initial state has default values', () {
      final state = notifier.state;
      expect(state.query, isEmpty);
      expect(state.selectedCategory, isNull);
      expect(state.stockStatus, equals(StockStatus.all));
      expect(state.sortField, equals(SortField.createdAt));
      expect(state.sortAscending, isFalse);
    });

    test('setQuery updates query', () {
      notifier.setQuery('test');
      expect(notifier.state.query, equals('test'));
    });

    test('setQuery with empty string clears query', () {
      notifier.setQuery('test');
      notifier.setQuery('');
      expect(notifier.state.query, isEmpty);
    });

    test('initDraft creates draft from current state', () {
      notifier.setQuery('test');
      notifier.initDraft();

      final draft = notifier.draft;
      expect(draft, isNotNull);
      expect(draft!.selectedCategory, isNull);
      expect(draft.stockStatus, equals(StockStatus.all));
    });

    test('stageCategory modifies draft', () {
      notifier.initDraft();
      notifier.stageCategory('Electronics');

      final draft = notifier.draft;
      expect(draft!.selectedCategory, equals('Electronics'));
    });

    test('stageStockStatus modifies draft', () {
      notifier.initDraft();
      notifier.stageStockStatus(StockStatus.low);

      final draft = notifier.draft;
      expect(draft!.stockStatus, equals(StockStatus.low));
    });

    test('applyDraft commits draft to state', () {
      notifier.initDraft();
      notifier.stageCategory('Electronics');
      notifier.stageStockStatus(StockStatus.low);
      notifier.applyDraft();

      expect(notifier.state.selectedCategory, equals('Electronics'));
      expect(notifier.state.stockStatus, equals(StockStatus.low));
      expect(notifier.draft, isNull);
    });

    test('discardDraft clears draft without changing state', () {
      notifier.initDraft();
      notifier.stageCategory('Electronics');
      notifier.discardDraft();

      expect(notifier.draft, isNull);
      expect(notifier.state.selectedCategory, isNull);
    });

    test('clearFilters resets state and draft', () {
      notifier.setQuery('test');
      notifier.initDraft();
      notifier.stageCategory('Electronics');

      notifier.clearFilters();

      final state = notifier.state;
      expect(state.query, isEmpty);
      expect(state.selectedCategory, isNull);
      expect(state.stockStatus, equals(StockStatus.all));
      expect(state.sortField, equals(SortField.createdAt));
      expect(state.sortAscending, isFalse);
      expect(notifier.draft, isNull);
    });

    test('setSortField toggles ascending when same field', () {
      notifier.setSortField(SortField.name);
      expect(notifier.state.sortField, equals(SortField.name));
      expect(notifier.state.sortAscending, isTrue);

      notifier.setSortField(SortField.name);
      expect(notifier.state.sortAscending, isFalse);
    });

    test('setSortField resets to ascending when different field', () {
      notifier.setSortField(SortField.name);
      notifier.setSortField(SortField.name);
      expect(notifier.state.sortAscending, isFalse);

      notifier.setSortField(SortField.price);
      expect(notifier.state.sortField, equals(SortField.price));
      expect(notifier.state.sortAscending, isTrue);
    });
  });

  group('FilterState', () {
    test('hasActiveFilters returns false when no filters active', () {
      const state = FilterState();
      expect(state.hasActiveFilters, isFalse);
    });

    test('hasActiveFilters returns true when query is set', () {
      const state = FilterState(query: 'test');
      expect(state.hasActiveFilters, isTrue);
    });

    test('hasActiveFilters returns true when category is set', () {
      const state = FilterState(selectedCategory: 'Electronics');
      expect(state.hasActiveFilters, isTrue);
    });

    test('hasActiveFilters returns true when stockStatus is not all', () {
      const state = FilterState(stockStatus: StockStatus.low);
      expect(state.hasActiveFilters, isTrue);
    });

    test('activeFilterCount returns correct count', () {
      const state = FilterState();
      expect(state.activeFilterCount, equals(0));

      const withCategory = FilterState(selectedCategory: 'Electronics');
      expect(withCategory.activeFilterCount, equals(1));

      const withBoth = FilterState(
        selectedCategory: 'Electronics',
        stockStatus: StockStatus.low,
      );
      expect(withBoth.activeFilterCount, equals(2));
    });

    test('copyWith creates new instance with updated values', () {
      const original = FilterState();
      final updated = original.copyWith(query: 'test');

      expect(updated.query, equals('test'));
      expect(original.query, isEmpty);
    });

    test('copyWith with null function keeps existing value', () {
      const original = FilterState(selectedCategory: 'Electronics');
      final updated = original.copyWith();

      expect(updated.selectedCategory, equals('Electronics'));
    });
  });

  group('FilterDraft', () {
    test('activeCount returns correct count', () {
      final draft = FilterDraft();
      expect(draft.activeCount, equals(0));

      draft.selectedCategory = 'Electronics';
      expect(draft.activeCount, equals(1));

      draft.stockStatus = StockStatus.low;
      expect(draft.activeCount, equals(2));
    });

    test('copy creates independent copy', () {
      final original = FilterDraft(
        selectedCategory: 'Electronics',
        stockStatus: StockStatus.low,
      );
      final copy = original.copy();

      copy.selectedCategory = 'Food';
      expect(original.selectedCategory, equals('Electronics'));
      expect(copy.selectedCategory, equals('Food'));
    });

    test('hasChanges returns false when draft matches applied state', () {
      const applied = FilterState(
        selectedCategory: 'Electronics',
        stockStatus: StockStatus.low,
      );
      final draft = FilterDraft(
        selectedCategory: 'Electronics',
        stockStatus: StockStatus.low,
      );

      expect(draft.hasChanges(applied), isFalse);
    });

    test('hasChanges returns true when category differs', () {
      const applied = FilterState(
        selectedCategory: 'Electronics',
        stockStatus: StockStatus.low,
      );
      final draft = FilterDraft(
        selectedCategory: 'Food',
        stockStatus: StockStatus.low,
      );

      expect(draft.hasChanges(applied), isTrue);
    });

    test('hasChanges returns true when stock status differs', () {
      const applied = FilterState(
        selectedCategory: 'Electronics',
        stockStatus: StockStatus.low,
      );
      final draft = FilterDraft(
        selectedCategory: 'Electronics',
        stockStatus: StockStatus.high,
      );

      expect(draft.hasChanges(applied), isTrue);
    });

    test('hasChanges returns true when clearing applied filters', () {
      const applied = FilterState(
        selectedCategory: 'Electronics',
        stockStatus: StockStatus.low,
      );
      final draft = FilterDraft();

      expect(draft.hasChanges(applied), isTrue);
    });
  });
}
