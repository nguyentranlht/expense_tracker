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
}

class DateFormatter {
  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _monthYearFormat = DateFormat('MM/yyyy');
  static final DateFormat _fullDateFormat = DateFormat('EEEE, dd MMMM yyyy');

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