import 'package:intl/intl.dart';

extension CurrencyFormatting on String {
  String formatAsCurrency() {
    final currencyFormat =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
    final valueAsDouble = double.tryParse(this) ?? 0.0;
    return currencyFormat.format(valueAsDouble);
  }
}

extension StringToDouble on String {
  double toDoubleOrDefault(double defaultValue) {
    try {
      return double.parse(this);
    } catch (e) {
      return defaultValue;
    }
  }
}
