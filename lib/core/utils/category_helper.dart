import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/constants.dart';

class CategoryHelper {
  // Get category color from Constants
  static Color getCategoryColor(String category) {
    final categoryData = Constants.defaultCategories.firstWhere(
      (cat) => cat['name'] == category,
      orElse: () => Constants.defaultCategories.last,
    );

    final colorHex = categoryData['color'] as String;
    return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
  }

  // Get category icon from Constants
  static IconData getCategoryIcon(String category) {
    final categoryData = Constants.defaultCategories.firstWhere(
      (cat) => cat['name'] == category,
      orElse: () => Constants.defaultCategories.last,
    );

    final iconName = categoryData['icon'] as String;
    return _getIconDataFromString(iconName);
  }

  // Get category data (for cases when you need both color and icon)
  static Map<String, dynamic> getCategoryData(String category) {
    return Constants.defaultCategories.firstWhere(
      (cat) => cat['name'] == category,
      orElse: () => Constants.defaultCategories.last,
    );
  }

  // Get all category names
  static List<String> getAllCategoryNames() {
    return Constants.defaultCategories
        .map((cat) => cat['name'] as String)
        .toList();
  }

  // Check if category exists
  static bool categoryExists(String category) {
    return Constants.defaultCategories
        .any((cat) => cat['name'] == category);
  }

  // Get category color with opacity
  static Color getCategoryColorWithOpacity(String category, double opacity) {
    return getCategoryColor(category).withOpacity(opacity);
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
      case 'ellipsis':
      default:
        return FontAwesomeIcons.ellipsis;
    }
  }

  // Widget builders for common use cases
  static Widget buildCategoryIcon(String category, {double size = 20}) {
    return FaIcon(
      getCategoryIcon(category),
      color: getCategoryColor(category),
      size: size,
    );
  }

  static Widget buildCategoryIconContainer(
    String category, {
    double size = 20,
    double padding = 8,
    double borderRadius = 8,
  }) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: getCategoryColorWithOpacity(category, 0.1),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: buildCategoryIcon(category, size: size),
    );
  }

  static Widget buildCategoryChip(
    String category, {
    double fontSize = 12,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: getCategoryColorWithOpacity(category, 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: getCategoryColorWithOpacity(category, 0.3),
          width: 1,
        ),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: getCategoryColor(category),
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}