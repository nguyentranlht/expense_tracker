import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/constants.dart';

class CategoryHelper {
  // Get category color from Constants (supports both income and expense)
  static Color getCategoryColor(String category, {String type = 'expense'}) {
    final categories = type == 'income' 
        ? Constants.defaultIncomeCategories 
        : Constants.defaultCategories;
        
    final categoryData = categories.firstWhere(
      (cat) => cat['name'] == category,
      orElse: () => _findCategoryInAllLists(category) ?? categories.last,
    );

    final colorHex = categoryData['color'] as String;
    return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
  }

  // Get category icon from Constants (supports both income and expense)
  static IconData getCategoryIcon(String category, {String type = 'expense'}) {
    final categories = type == 'income' 
        ? Constants.defaultIncomeCategories 
        : Constants.defaultCategories;
        
    final categoryData = categories.firstWhere(
      (cat) => cat['name'] == category,
      orElse: () => _findCategoryInAllLists(category) ?? categories.last,
    );

    final iconName = categoryData['icon'] as String;
    return _getIconDataFromString(iconName);
  }

  // Helper method to find category in all lists when not found in primary list
  static Map<String, dynamic>? _findCategoryInAllLists(String category) {
    // First try income categories
    try {
      return Constants.defaultIncomeCategories.firstWhere(
        (cat) => cat['name'] == category,
      );
    } catch (e) {
      // Then try expense categories
      try {
        return Constants.defaultCategories.firstWhere(
          (cat) => cat['name'] == category,
        );
      } catch (e) {
        return null;
      }
    }
  }

  // Get category data (for cases when you need both color and icon)
  static Map<String, dynamic> getCategoryData(String category, {String type = 'expense'}) {
    final categories = type == 'income' 
        ? Constants.defaultIncomeCategories 
        : Constants.defaultCategories;
        
    return categories.firstWhere(
      (cat) => cat['name'] == category,
      orElse: () => _findCategoryInAllLists(category) ?? categories.last,
    );
  }

  // Get all category names for specific type
  static List<String> getAllCategoryNames({String type = 'expense'}) {
    final categories = type == 'income' 
        ? Constants.defaultIncomeCategories 
        : Constants.defaultCategories;
    return categories.map((cat) => cat['name'] as String).toList();
  }

  // Get all category names (both income and expense)
  static List<String> getAllCategoryNamesAll() {
    final expenseNames = Constants.defaultCategories.map((cat) => cat['name'] as String);
    final incomeNames = Constants.defaultIncomeCategories.map((cat) => cat['name'] as String);
    return [...expenseNames, ...incomeNames];
  }

  // Check if category exists in any list
  static bool categoryExists(String category) {
    return Constants.defaultCategories.any((cat) => cat['name'] == category) ||
           Constants.defaultIncomeCategories.any((cat) => cat['name'] == category);
  }

  // Get category color with opacity
  static Color getCategoryColorWithOpacity(String category, double opacity, {String type = 'expense'}) {
    return getCategoryColor(category, type: type).withOpacity(opacity);
  }

  // Helper method to convert string to IconData
  static IconData _getIconDataFromString(String iconName) {
    switch (iconName) {
      case 'utensils':
        return FontAwesomeIcons.utensils;
      case 'gas_pump':
        return FontAwesomeIcons.gasPump;
      case 'bag_shopping':
        return FontAwesomeIcons.bagShopping;
      case 'gamepad':
        return FontAwesomeIcons.gamepad;
      case 'heart_pulse':
        return FontAwesomeIcons.heartPulse;
      case 'graduation_cap':
        return FontAwesomeIcons.graduationCap;
      case 'house':
        return FontAwesomeIcons.house;
      case 'money_bill':
        return FontAwesomeIcons.moneyBill;
      case 'gift':
        return FontAwesomeIcons.gift;
      case 'chart_line':
        return FontAwesomeIcons.chartLine;
      case 'store':
        return FontAwesomeIcons.store;
      case 'laptop':
        return FontAwesomeIcons.laptop;
      case 'plus_circle':
        return FontAwesomeIcons.plusCircle;
      case 'ellipsis':
      default:
        return FontAwesomeIcons.ellipsis;
    }
  }

  // Widget builders for common use cases
  static Widget buildCategoryIcon(String category, {double size = 20, String type = 'expense'}) {
    return FaIcon(
      getCategoryIcon(category, type: type),
      color: getCategoryColor(category, type: type),
      size: size,
    );
  }

  static Widget buildCategoryIconContainer(
    String category, {
    double size = 20,
    double borderRadius = 8,
    String type = 'expense',
  }) {
    return Container(
      alignment: Alignment.center,
      width: size + 16.r,
      height: size + 16.r,
      decoration: BoxDecoration(
        color: getCategoryColorWithOpacity(category, 0.1, type: type),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: buildCategoryIcon(category, size: size, type: type),
    );
  }

  static Widget buildCategoryChip(
    String category, {
    double fontSize = 12,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    String type = 'expense',
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: getCategoryColorWithOpacity(category, 0.1, type: type),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: getCategoryColorWithOpacity(category, 0.3, type: type),
          width: 1,
        ),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: getCategoryColor(category, type: type),
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}