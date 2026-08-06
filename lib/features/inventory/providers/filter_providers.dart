import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/features/inventory/data/models/product.dart';
import 'package:inventory_app/features/inventory/providers/inventory_providers.dart';

enum SortField { name, quantity, price, createdAt }

enum StockStatus { all, low, normal, high }

class FilterDraft {
  String? selectedCategory;
  StockStatus stockStatus;

  FilterDraft({
    this.selectedCategory,
    this.stockStatus = StockStatus.all,
  });

  FilterDraft copy() {
    return FilterDraft(
      selectedCategory: selectedCategory,
      stockStatus: stockStatus,
    );
  }

  int get activeCount {
    int count = 0;
    if (selectedCategory != null) count++;
    if (stockStatus != StockStatus.all) count++;
    return count;
  }

  bool hasChanges(FilterState applied) {
    return selectedCategory != applied.selectedCategory ||
        stockStatus != applied.stockStatus;
  }
}

class FilterState {
  final String query;
  final String? selectedCategory;
  final StockStatus stockStatus;
  final SortField sortField;
  final bool sortAscending;

  const FilterState({
    this.query = '',
    this.selectedCategory,
    this.stockStatus = StockStatus.all,
    this.sortField = SortField.createdAt,
    this.sortAscending = false,
  });

  FilterState copyWith({
    String? query,
    String? Function()? selectedCategory,
    StockStatus? stockStatus,
    SortField? sortField,
    bool? sortAscending,
  }) {
    return FilterState(
      query: query ?? this.query,
      selectedCategory:
          selectedCategory != null ? selectedCategory() : this.selectedCategory,
      stockStatus: stockStatus ?? this.stockStatus,
      sortField: sortField ?? this.sortField,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  bool get hasActiveFilters =>
      query.isNotEmpty ||
      selectedCategory != null ||
      stockStatus != StockStatus.all;

  int get activeFilterCount {
    int count = 0;
    if (selectedCategory != null) count++;
    if (stockStatus != StockStatus.all) count++;
    return count;
  }
}

class FilterNotifier extends StateNotifier<FilterState> {
  FilterDraft? _draft;

  FilterNotifier() : super(const FilterState());

  FilterDraft? get draft => _draft;

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void initDraft() {
    _draft = FilterDraft(
      selectedCategory: state.selectedCategory,
      stockStatus: state.stockStatus,
    );
  }

  void stageCategory(String? category) {
    _draft?.selectedCategory = category;
  }

  void stageStockStatus(StockStatus status) {
    _draft?.stockStatus = status;
  }

  void applyDraft() {
    if (_draft == null) return;
    state = state.copyWith(
      selectedCategory: () => _draft!.selectedCategory,
      stockStatus: _draft!.stockStatus,
    );
    _draft = null;
  }

  void discardDraft() {
    _draft = null;
  }

  void clearFilters() {
    state = const FilterState();
    _draft = null;
  }

  void setSortField(SortField field) {
    if (state.sortField == field) {
      state = state.copyWith(sortAscending: !state.sortAscending);
    } else {
      state = state.copyWith(sortField: field, sortAscending: true);
    }
  }
}

final filterProvider =
    StateNotifierProvider<FilterNotifier, FilterState>((ref) {
  return FilterNotifier();
});

final filteredProductsProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(inventoryProvider);
  final filter = ref.watch(filterProvider);

  var result = List<Product>.from(products);

  if (filter.query.isNotEmpty) {
    final lowerQuery = filter.query.toLowerCase();
    result = result.where((p) {
      return p.name.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  if (filter.selectedCategory != null) {
    result = result.where((p) => p.category == filter.selectedCategory).toList();
  }

  if (filter.stockStatus != StockStatus.all) {
    result = result.where((p) {
      switch (filter.stockStatus) {
        case StockStatus.low:
          return p.quantity < p.minStock;
        case StockStatus.normal:
          return p.quantity >= p.minStock && p.quantity <= p.minStock * 2;
        case StockStatus.high:
          return p.quantity > p.minStock * 2;
        default:
          return true;
      }
    }).toList();
  }

  result.sort((a, b) {
    int comparison;
    switch (filter.sortField) {
      case SortField.name:
        comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      case SortField.quantity:
        comparison = a.quantity.compareTo(b.quantity);
      case SortField.price:
        comparison = a.price.compareTo(b.price);
      case SortField.createdAt:
        comparison = a.createdAt.compareTo(b.createdAt);
    }
    return filter.sortAscending ? comparison : -comparison;
  });

  return result;
});
