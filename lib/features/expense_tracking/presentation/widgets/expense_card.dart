import 'package:expense_tracker/core/utils/localization_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/utils/category_helper.dart';
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                    CategoryHelper.buildCategoryIconContainer(
                      expense.category,
                      size: 20,
                      padding: 12,
                      borderRadius: 12,
                    ),

                    const SizedBox(width: 12),

                    // Title and Category
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 2),
                          CategoryHelper.buildCategoryChip(
                            expense.category,
                            fontSize: 12,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          ),
                          Text(
                            expense.title,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Amount
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${expense.isIncome ? '+' : '-'}${CurrencyFormatter.format(expense.amount)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: expense.isIncome ? Colors.green : Colors.red,
                          ),
                        ),
                        Text(
                          DateFormatter.formatDate(
                            expense.date,
                            context.l10n.localeName,
                          ),
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
                          DateFormatter.formatTime(
                            expense.createdAt,
                            context.l10n.localeName,
                          ),
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


}
