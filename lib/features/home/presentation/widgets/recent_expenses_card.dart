import 'package:expense_tracker/core/utils/localization_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../expense_tracking/domain/entities/expense.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/category_helper.dart';

class RecentExpensesCard extends StatelessWidget {
  final List<Expense> expenses;
  final VoidCallback? onViewAllPressed;

  const RecentExpensesCard({
    super.key,
    required this.expenses,
    this.onViewAllPressed,
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
                FaIcon(
                  FontAwesomeIcons.clockRotateLeft,
                  size: 18.sp,
                ),
                const SizedBox(width: 8),
                 Text(
                  context.l10n.recent_expenses_card,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onViewAllPressed,
                  child: Text(context.l10n.viewAll,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            if (expenses.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    context.l10n.noExpenses,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: expenses.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CategoryHelper.buildCategoryIconContainer(
                      expense.category,
                      size: 22.sp,
                      borderRadius: 8,
                    ),
                    title: Text(
                      expense.category,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      expense.title,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.sp,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${expense.isIncome ? '+' : '-'}${CurrencyFormatter.format(expense.amount)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: expense.isIncome ? Colors.green : Colors.red,
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          DateFormatter.formatShortDate(expense.date, context.l10n.localeName),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
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


}