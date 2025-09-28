import 'package:expense_tracker/core/utils/localization_helper.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/core/extensions/context_extensions.dart';
import 'package:expense_tracker/core/utils/formatters.dart';

class MonthPickerBottomSheet extends StatelessWidget {
  final DateTime selectedMonth;
  final ValueChanged<DateTime> onMonthSelected;
  final bool showAllMonths;
  final VoidCallback onShowAllSelected;

  const MonthPickerBottomSheet({
    super.key,
    required this.selectedMonth,
    required this.onMonthSelected,
    required this.showAllMonths,
    required this.onShowAllSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              context.l10n.selectMonth,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.cs.onSurface,
              ),
            ),
          ),
          // Tùy chọn "Xem tất cả"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: GestureDetector(
              onTap: () {
                onShowAllSelected();
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: showAllMonths ? context.cs.primary : context.cs.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: showAllMonths ? context.cs.primary : Colors.grey[300]!,
                  ),
                ),
                child: Center(
                  child: Text(
                    context.l10n.viewAll,
                    style: TextStyle(
                      color: showAllMonths ? Colors.white : context.cs.onSurface,
                      fontWeight: showAllMonths ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                final month = index + 1;
                final monthDate = DateTime(selectedMonth.year, month);
                final isSelected = !showAllMonths && monthDate.month == selectedMonth.month;

                return GestureDetector(
                  onTap: () {
                    onMonthSelected(monthDate);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? context.cs.primary : context.cs.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? context.cs.primary : Colors.grey[300]!,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        DateFormatter.formatMonth(monthDate, context.l10n.localeName),
                        style: TextStyle(
                          color: isSelected ? Colors.white : context.cs.onSurface,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}