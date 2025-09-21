import 'package:expense_tracker/core/utils/localization_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../expense_tracking/domain/entities/expense.dart';
import '../../../../core/utils/formatters.dart';

class RecentExpensesCard extends StatelessWidget {
  final List<Expense> expenses;

  const RecentExpensesCard({
    super.key,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.clockRotateLeft,
                  size: 20,
                ),
                const SizedBox(width: 8),
                 Text(
                  context.l10n.recent_expenses_card,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // Switch to expenses tab
                  },
                  child: Text(context.l10n.viewAll),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            if (expenses.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Chưa có chi tiêu nào',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: expenses.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(expense.category).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: FaIcon(
                        _getCategoryIcon(expense.category),
                        color: _getCategoryColor(expense.category),
                        size: 16,
                      ),
                    ),
                    title: Text(
                      expense.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      expense.category,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          CurrencyFormatter.format(expense.amount),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          DateFormatter.formatShortDate(expense.date, context.l10n.localeName),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Ăn uống':
        return Colors.orange;
      case 'Xăng xe':
        return Colors.blue;
      case 'Mua sắm':
        return Colors.purple;
      case 'Giải trí':
        return Colors.pink;
      case 'Y tế':
        return Colors.red;
      case 'Giáo dục':
        return Colors.green;
      case 'Nhà ở':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Ăn uống':
        return FontAwesomeIcons.utensils;
      case 'Xăng xe':
        return FontAwesomeIcons.gasPump;
      case 'Mua sắm':
        return FontAwesomeIcons.bagShopping;
      case 'Giải trí':
        return FontAwesomeIcons.gamepad;
      case 'Y tế':
        return FontAwesomeIcons.heartPulse;
      case 'Giáo dục':
        return FontAwesomeIcons.graduationCap;
      case 'Nhà ở':
        return FontAwesomeIcons.house;
      default:
        return FontAwesomeIcons.ellipsis;
    }
  }
}