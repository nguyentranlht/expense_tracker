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
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _shortDateFormat = DateFormat('dd/MM');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _monthYearFormat = DateFormat('MM/yyyy');
  static final DateFormat _fullDateFormat = DateFormat('EEEE, dd MMMM yyyy');

  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  static String formatShortDate(DateTime date) {
    return _shortDateFormat.format(date);
  }

  static String formatTime(DateTime date) {
    return _timeFormat.format(date);
  }

  static String formatDateTime(DateTime date) {
    return _dateTimeFormat.format(date);
  }

  static String formatMonthYear(DateTime date) {
    return _monthYearFormat.format(date);
  }

  static String formatFullDate(DateTime date) {
    return _fullDateFormat.format(date);
  }
}