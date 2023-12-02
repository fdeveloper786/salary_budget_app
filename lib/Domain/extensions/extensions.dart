import 'package:intl/intl.dart';

extension CurrencyFormatting on String {
  String formatAsCurrency() {
    final currencyFormat =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
    final valueAsDouble = double.tryParse(this) ?? 0.0;
    return currencyFormat.format(valueAsDouble);
  }
}

extension RupeeSymbolExtension on String {
  String withRupeeSymbol() {
    return '₹$this';
  }
}
