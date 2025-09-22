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
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    } else {
      return amount.toStringAsFixed(0);
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
    return DateFormat.yMMM(locale).format(date);
  }

  static String formatFullDate(DateTime date, String? locale) {
    return DateFormat.yMMMMEEEEd(locale).format(date);
  }
}