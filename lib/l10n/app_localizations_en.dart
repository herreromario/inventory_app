// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Inventory App';

  @override
  String get navInventory => 'Inventory';

  @override
  String get navMovements => 'Movements';

  @override
  String get navStats => 'Stats';

  @override
  String get noItemsFound => 'No items found';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get searchProducts => 'Search products...';

  @override
  String get filters => 'Filters';

  @override
  String get sort => 'Sort';

  @override
  String get noMatchingProducts => 'No matching products';

  @override
  String get deleteProduct => 'Delete Product';

  @override
  String confirmDeleteProduct(Object name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get noProductsYet => 'No products yet';

  @override
  String get productAddedSuccessfully => 'Product added successfully';

  @override
  String get addProduct => 'Add Product';

  @override
  String get productNameLabel => 'Product Name *';

  @override
  String get productNameRequired => 'Please enter a product name';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get quantityLabel => 'Quantity *';

  @override
  String get required => 'Required';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String get minStockLabel => 'Min Stock *';

  @override
  String get priceLabel => 'Price *';

  @override
  String get invalidPrice => 'Invalid price';

  @override
  String get skuLabel => 'SKU';

  @override
  String get productUpdated => 'Product updated';

  @override
  String get productDetail => 'Product Detail';

  @override
  String get productNotFound => 'Product not found';

  @override
  String get editProduct => 'Edit Product';

  @override
  String get categoryLabel => 'Category';

  @override
  String get noCategory => 'Sin categoría';

  @override
  String createdDate(Object date) {
    return 'Created: $date';
  }

  @override
  String updatedDate(Object date) {
    return 'Updated: $date';
  }

  @override
  String movementHistoryCount(Object count) {
    return 'Movement History ($count)';
  }

  @override
  String get noMovementsYet => 'No movements yet';

  @override
  String get deleteMovement => 'Delete Movement';

  @override
  String get confirmDeleteMovement =>
      'Are you sure you want to delete this movement?';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get pleaseSelectProduct => 'Please select a product';

  @override
  String get movementUpdated => 'Movement updated';

  @override
  String get movementRegistered => 'Movement registered';

  @override
  String get editMovement => 'Edit Movement';

  @override
  String get addMovement => 'Add Movement';

  @override
  String currentStock(Object quantity) {
    return 'Current stock: $quantity';
  }

  @override
  String get productLabel => 'Product *';

  @override
  String get entry => 'Entry';

  @override
  String get exit => 'Exit';

  @override
  String get mustBePositive => 'Must be a positive number';

  @override
  String cannotExceedStock(Object quantity) {
    return 'Cannot exceed available stock ($quantity)';
  }

  @override
  String get reasonLabel => 'Reason *';

  @override
  String get registerMovement => 'Register Movement';

  @override
  String get movementHistory => 'Movement History';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get inventorySummary => 'Inventory Summary';

  @override
  String get totalProducts => 'Total products';

  @override
  String get totalValue => 'Total value';

  @override
  String get lowStock => 'Low Stock';

  @override
  String get recentMovementsLabel => 'Recent Movements';

  @override
  String get viewAllCategories => 'View all categories →';

  @override
  String get categories => 'Categories';

  @override
  String get noCategoriesYet => 'No categories yet';

  @override
  String get deleteCategory => 'Delete Category';

  @override
  String confirmDeleteCategory(Object name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get newCategory => 'New Category';

  @override
  String get categoryNameLabel => 'Category Name';

  @override
  String get create => 'Create';

  @override
  String get editCategory => 'Edit Category';

  @override
  String get save => 'Save';

  @override
  String get valueByCategory => 'Value by Category';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get totalInventory => 'Total Inventory';

  @override
  String categoriesCount(Object count) {
    return '$count categories';
  }

  @override
  String get noProducts => 'No products';

  @override
  String get categoriesByValue => 'Categories by Value';

  @override
  String get latestMovements => 'Latest Movements';

  @override
  String get unknownProduct => 'Unknown Product';

  @override
  String get entryType => 'Entry';

  @override
  String get exitType => 'Exit';

  @override
  String get noDataToShow => 'No data to show';

  @override
  String get addProductsAndViewStats =>
      'Add products and record movements\nto view inventory statistics.';

  @override
  String get registerProducts => 'Register products';

  @override
  String get controlEntryExit => 'Control entries and exits';

  @override
  String get viewKeyMetrics => 'View key metrics';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(Object count) {
    return '$count days ago';
  }

  @override
  String get currencySymbol => '\$';

  @override
  String get quantityAbbreviation => 'Qty';

  @override
  String quantityAndPrice(Object price, Object quantity) {
    return 'Qty: $quantity · \$$price';
  }

  @override
  String moreProducts(Object count) {
    return '+$count more products';
  }

  @override
  String get sortBy => 'Sort by';

  @override
  String get sortName => 'Name';

  @override
  String get sortQuantity => 'Quantity';

  @override
  String get sortPrice => 'Price';

  @override
  String get sortDate => 'Date';

  @override
  String get clear => 'Clear';

  @override
  String get allCategories => 'All categories';

  @override
  String get stockStatus => 'Stock Status';

  @override
  String get all => 'All';

  @override
  String get low => 'Low';

  @override
  String get normal => 'Normal';

  @override
  String get high => 'High';

  @override
  String get showResults => 'Show results';

  @override
  String showResultsCount(Object count) {
    return 'Show results ($count)';
  }

  @override
  String get clearFilters => 'Clear filters';
}
