import 'package:intl/intl.dart';
import '../constants/constants.dart';

class CurrencyFormatter {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: Constants.locale,
    symbol: Constants.currencySymbol,
    decimalDigits: 0, // Remove decimal places for VND
  );

  static String format(double amount) {
    return _currencyFormat.format(amount);
  }

  static String formatCompact(double amount) {
    final absAmount = amount.abs();
    final sign = amount < 0 ? '-' : '';
    
    if (absAmount >= 1000000) {
      return '$sign${(absAmount / 1000000).toStringAsFixed(0)}M';
    } else if (absAmount >= 1000) {
      return '$sign${(absAmount / 1000).toStringAsFixed(0)}K';
    } else {
      return '$sign${absAmount.toStringAsFixed(0)}';
    }
  }
}

class DateFormatter {

  static String formatDate(DateTime date, String? locale) {
    return DateFormat.yMd(locale).format(date);
  }

  static String formatShortDate(DateTime date, String? locale) {
    return DateFormat.Md(locale).format(date);
  }

  static String formatTime(DateTime date, String? locale) {
    return DateFormat.Hm(locale).format(date);
  }

  static String formatDateTime(DateTime date, String? locale) {
    return DateFormat.yMd(locale).add_Hm().format(date);
  }

  static String formatMonthYear(DateTime date, String? locale) {
    return DateFormat.yMMMM(locale).format(date);
  }

  static String formatFullDate(DateTime date, String? locale) {
    return DateFormat.yMMMMEEEEd(locale).format(date);
  }
}