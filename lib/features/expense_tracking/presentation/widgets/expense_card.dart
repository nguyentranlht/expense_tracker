import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/expense.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const ExpenseCard({
    super.key,
    required this.expense,
    this.onTap,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Category Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(expense.category).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FaIcon(
                        _getCategoryIcon(expense.category),
                        color: _getCategoryColor(expense.category),
                        size: 20,
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Title and Category
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expense.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(expense.category).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _getCategoryColor(expense.category).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              expense.category,
                              style: TextStyle(
                                color: _getCategoryColor(expense.category),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Amount
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          CurrencyFormatter.format(expense.amount),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          DateFormatter.formatDate(expense.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                // Description
                if (expense.description.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    expense.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                
                // Footer Row
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Time
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.clock,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormatter.formatTime(expense.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    
                    const Spacer(),
                    
                    // Action Buttons
                    Row(
                      children: [
                        if (onEdit != null)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: onEdit,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: FaIcon(
                                  FontAwesomeIcons.penToSquare,
                                  size: 16,
                                  color: Colors.blue[600],
                                ),
                              ),
                            ),
                          ),
                        if (onDelete != null) ...[
                          const SizedBox(width: 8),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: onDelete,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: FaIcon(
                                  FontAwesomeIcons.trashCan,
                                  size: 16,
                                  color: Colors.red[600],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    final categoryData = Constants.defaultCategories.firstWhere(
      (cat) => cat['name'] == category,
      orElse: () => Constants.defaultCategories.last,
    );
    
    final colorHex = categoryData['color'] as String;
    return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
  }

  IconData _getCategoryIcon(String category) {
    final categoryData = Constants.defaultCategories.firstWhere(
      (cat) => cat['name'] == category,
      orElse: () => Constants.defaultCategories.last,
    );
    
    final iconName = categoryData['icon'] as String;
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
      default:
        return FontAwesomeIcons.ellipsis;
    }
  }
}