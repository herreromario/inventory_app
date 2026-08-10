import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatCurrency(BuildContext context, double amount) {
  final isEs = Localizations.localeOf(context).languageCode == 'es';
  final symbol = isEs ? '€' : '\$';
  return NumberFormat.currency(locale: isEs ? 'es_ES' : 'en_US', symbol: symbol).format(amount);
}
