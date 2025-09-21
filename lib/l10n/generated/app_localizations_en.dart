// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Expense Tracker';

  @override
  String get hello => 'Hello';

  @override
  String get expenses => 'Expenses';

  @override
  String get addExpense => 'Add Expense';

  @override
  String get amount => 'Amount';

  @override
  String get description => 'Description';

  @override
  String get category => 'Category';

  @override
  String get date => 'Date';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get totalExpenses => 'Total Expenses';

  @override
  String get noExpenses => 'No expenses found';

  @override
  String get currencySymbol => '\$';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get notifications => 'Notifications';

  @override
  String get recent_expenses_card => 'Recent Expenses';

  @override
  String get error => 'An error occurred!';

  @override
  String get balance => 'Balance';

  @override
  String get transactions => 'Transactions';

  @override
  String get avg_month => 'Avg/month';

  @override
  String get today => 'Today';
}
