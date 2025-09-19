class Constants {
  // Database
  static const String databaseName = 'expense_tracker.db';
  static const int databaseVersion = 1;
  
  // Tables
  static const String expenseTable = 'expenses';
  static const String categoryTable = 'categories';
  static const String settingsTable = 'settings';
  
  // Date formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  
  // Categories with icons and colors
  static const List<Map<String, dynamic>> defaultCategories = [
    {
      'name': 'Ăn uống',
      'icon': 'utensils',
      'color': '#FF9800',
    },
    {
      'name': 'Xăng xe',
      'icon': 'gas_pump',
      'color': '#2196F3',
    },
    {
      'name': 'Mua sắm',
      'icon': 'bag_shopping',
      'color': '#9C27B0',
    },
    {
      'name': 'Giải trí',
      'icon': 'gamepad',
      'color': '#E91E63',
    },
    {
      'name': 'Y tế',
      'icon': 'heart_pulse',
      'color': '#F44336',
    },
    {
      'name': 'Giáo dục',
      'icon': 'graduation_cap',
      'color': '#4CAF50',
    },
    {
      'name': 'Nhà ở',
      'icon': 'house',
      'color': '#795548',
    },
    {
      'name': 'Khác',
      'icon': 'ellipsis',
      'color': '#9E9E9E',
    },
  ];
  
  // Default currency
  static const String defaultCurrency = 'VNĐ';
  static const String currencySymbol = '₫';
  static const String locale = 'vi_VN';
  
  // App settings keys
  static const String themeMode = 'theme_mode';
  static const String language = 'language';
  static const String firstLaunch = 'first_launch';
}