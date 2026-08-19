// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Inventario';

  @override
  String get navInventory => 'Inventario';

  @override
  String get navMovements => 'Movimientos';

  @override
  String get navStats => 'Estadísticas';

  @override
  String get noItemsFound => 'No se encontraron elementos';

  @override
  String get delete => 'Eliminar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get searchProducts => 'Buscar productos...';

  @override
  String get filters => 'Filtros';

  @override
  String get sort => 'Ordenar';

  @override
  String get noMatchingProducts => 'No hay productos que coincidan';

  @override
  String get deleteProduct => 'Eliminar Producto';

  @override
  String confirmDeleteProduct(Object name) {
    return '¿Estás seguro de que quieres eliminar \"$name\"?';
  }

  @override
  String get noProductsYet => 'Aún no hay productos';

  @override
  String get productAddedSuccessfully => 'Producto agregado correctamente';

  @override
  String get addProduct => 'Agregar Producto';

  @override
  String get productNameLabel => 'Nombre del producto *';

  @override
  String get productNameRequired => 'Por favor ingresa un nombre de producto';

  @override
  String get descriptionLabel => 'Descripción';

  @override
  String get quantityLabel => 'Cantidad *';

  @override
  String get required => 'Requerido';

  @override
  String get invalidNumber => 'Número inválido';

  @override
  String get minStockLabel => 'Stock mínimo *';

  @override
  String get priceLabel => 'Precio *';

  @override
  String get invalidPrice => 'Precio inválido';

  @override
  String get skuLabel => 'SKU';

  @override
  String get productUpdated => 'Producto actualizado';

  @override
  String get productDetail => 'Detalle del Producto';

  @override
  String get productNotFound => 'Producto no encontrado';

  @override
  String get editProduct => 'Editar Producto';

  @override
  String get categoryLabel => 'Categoría';

  @override
  String get noCategory => 'Sin categoría';

  @override
  String createdDate(Object date) {
    return 'Creado: $date';
  }

  @override
  String updatedDate(Object date) {
    return 'Actualizado: $date';
  }

  @override
  String movementHistoryCount(Object count) {
    return 'Historial de Movimientos ($count)';
  }

  @override
  String get noMovementsYet => 'Aún no hay movimientos';

  @override
  String get deleteMovement => 'Eliminar Movimiento';

  @override
  String get confirmDeleteMovement =>
      '¿Estás seguro de que quieres eliminar este movimiento?';

  @override
  String get saveChanges => 'Guardar Cambios';

  @override
  String get pleaseSelectProduct => 'Por favor selecciona un producto';

  @override
  String get movementUpdated => 'Movimiento actualizado';

  @override
  String get movementRegistered => 'Movimiento registrado';

  @override
  String get editMovement => 'Editar Movimiento';

  @override
  String get addMovement => 'Agregar Movimiento';

  @override
  String currentStock(Object quantity) {
    return 'Stock actual: $quantity';
  }

  @override
  String get productLabel => 'Producto *';

  @override
  String get entry => 'Entrada';

  @override
  String get exit => 'Salida';

  @override
  String get mustBePositive => 'Debe ser un número positivo';

  @override
  String cannotExceedStock(Object quantity) {
    return 'No puede exceder el stock disponible ($quantity)';
  }

  @override
  String get reasonLabel => 'Razón *';

  @override
  String get registerMovement => 'Registrar Movimiento';

  @override
  String get movementHistory => 'Historial de Movimientos';

  @override
  String get dashboard => 'Panel';

  @override
  String get inventorySummary => 'Resumen del inventario';

  @override
  String get totalProducts => 'Total productos';

  @override
  String get totalValue => 'Valor total';

  @override
  String get lowStock => 'Stock bajo';

  @override
  String get recentMovementsLabel => 'Movimientos recientes';

  @override
  String get viewAllCategories => 'Ver todas las categorías →';

  @override
  String get categories => 'Categorías';

  @override
  String get noCategoriesYet => 'Aún no hay categorías';

  @override
  String get deleteCategory => 'Eliminar Categoría';

  @override
  String confirmDeleteCategory(Object name) {
    return '¿Estás seguro de que quieres eliminar \"$name\"?';
  }

  @override
  String get newCategory => 'Nueva Categoría';

  @override
  String get categoryNameLabel => 'Nombre de Categoría';

  @override
  String get create => 'Crear';

  @override
  String get editCategory => 'Editar Categoría';

  @override
  String get save => 'Guardar';

  @override
  String get valueByCategory => 'Valor por categoría';

  @override
  String get noDataAvailable => 'No hay datos disponibles';

  @override
  String get totalInventory => 'Total del Inventario';

  @override
  String categoriesCount(Object count) {
    return '$count categorías';
  }

  @override
  String get noProducts => 'No hay productos';

  @override
  String get categoriesByValue => 'Categorías por valor';

  @override
  String get latestMovements => 'Últimos movimientos';

  @override
  String get unknownProduct => 'Producto desconocido';

  @override
  String get entryType => 'Entrada';

  @override
  String get exitType => 'Salida';

  @override
  String get noDataToShow => 'Sin datos para mostrar';

  @override
  String get addProductsAndViewStats =>
      'Agrega productos y registra movimientos\npara ver las estadísticas del inventario.';

  @override
  String get registerProducts => 'Registra productos';

  @override
  String get controlEntryExit => 'Controla entradas y salidas';

  @override
  String get viewKeyMetrics => 'Visualiza métricas clave';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String daysAgo(Object count) {
    return 'Hace $count días';
  }

  @override
  String get currencySymbol => '€';

  @override
  String get quantityAbbreviation => 'Cant';

  @override
  String quantityAndPrice(Object price, Object quantity) {
    return 'Cant: $quantity · \$$price';
  }

  @override
  String moreProducts(Object count) {
    return '+$count productos más';
  }

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get sortName => 'Nombre';

  @override
  String get sortQuantity => 'Cantidad';

  @override
  String get sortPrice => 'Precio';

  @override
  String get sortDate => 'Fecha';

  @override
  String get clear => 'Limpiar';

  @override
  String get allCategories => 'Todas las categorías';

  @override
  String get stockStatus => 'Estado del stock';

  @override
  String get all => 'Todos';

  @override
  String get low => 'Bajo';

  @override
  String get normal => 'Normal';

  @override
  String get high => 'Alto';

  @override
  String get showResults => 'Mostrar resultados';

  @override
  String showResultsCount(Object count) {
    return 'Mostrar resultados ($count)';
  }

  @override
  String get clearFilters => 'Limpiar filtros';

  @override
  String get selectProduct => 'Seleccionar producto';

  @override
  String get productNameLabelNoStar => 'Nombre del Producto';

  @override
  String get quantityLabelNoStar => 'Cantidad';

  @override
  String get priceLabelNoStar => 'Precio';

  @override
  String get minStockLabelNoStar => 'Stock Mínimo';
}
