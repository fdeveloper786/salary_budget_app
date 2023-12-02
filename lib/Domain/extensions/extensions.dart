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

extension NumberFormatting on String {
  String formatWithCommas() {
    try {
      final value = double.parse(this);
      final formatter = NumberFormat('#,##,###');
      return formatter.format(value);
    } catch (e) {
      // Handle the case where the string is not a valid number
      return this;
    }
  }
}

extension RupeesFormatting on String {
  String formatRupees() {
    try {
      final value = double.parse(this);
      final formatter = NumberFormat('#,##,###', 'en_IN');
      return '₹${formatter.format(value)}';
    } catch (e) {
      // Handle the case where the string is not a valid number
      return this;
    }
  }
}
