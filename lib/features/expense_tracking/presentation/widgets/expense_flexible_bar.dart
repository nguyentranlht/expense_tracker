import 'package:expense_tracker/core/extensions/context_extensions.dart';
import 'package:expense_tracker/core/utils/formatters.dart';
import 'package:expense_tracker/core/utils/localization_helper.dart';
import 'package:expense_tracker/features/expense_tracking/presentation/widgets/modal_bottom_month.dart';
import 'package:expense_tracker/features/expense_tracking/presentation/widgets/summary_card.dart';
import 'package:flutter/material.dart';

enum FilterType {
  all,
  income,
  expense,
}

class ExpenseFlexibleBar extends StatefulWidget {
  final double totalIncome;
  final double totalExpense;
  final FilterType selectedFilter;
  final DateTime? selectedMonth;
  final bool showAllMonths;
  final bool isCollapsed;
  final double collapseRatio;
  final Function(FilterType) onFilterChanged;
  final Function(DateTime?) onMonthChanged;
  final Function(bool) onShowAllChanged;

  const ExpenseFlexibleBar({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
    required this.selectedFilter,
    required this.selectedMonth,
    required this.showAllMonths,
    required this.isCollapsed,
    required this.collapseRatio,
    required this.onFilterChanged,
    required this.onMonthChanged,
    required this.onShowAllChanged,
  });

  @override
  State<ExpenseFlexibleBar> createState() => _ExpenseFlexibleBarState();
}

class _ExpenseFlexibleBarState extends State<ExpenseFlexibleBar> {
  bool _isMonthPickerVisible = false;

  String _getDisplayText() {
    if (widget.showAllMonths) {
      return context.l10n.viewAll;
    }
    return DateFormatter.formatMonthYear(widget.selectedMonth!, context.l10n.localeName);
  }

  void _showMonthPicker() {
    setState(() {
      _isMonthPickerVisible = true;
    });
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return MonthPickerBottomSheet(
          selectedMonth: widget.selectedMonth ?? DateTime.now(),
          showAllMonths: widget.showAllMonths,
          onMonthSelected: (monthDate) {
            widget.onMonthChanged(monthDate);
            widget.onShowAllChanged(false);
          },
          onShowAllSelected: () {
            widget.onShowAllChanged(true);
            widget.onMonthChanged(null);
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        _isMonthPickerVisible = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.parallax,
      centerTitle: true,
      title: AnimatedOpacity(
        opacity: widget.isCollapsed ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mini card Chi
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E5C8A).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.trending_up_rounded,
                      color: Colors.white,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      CurrencyFormatter.formatCompact(widget.totalExpense),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Title
              Text(
                context.l10n.incomeExpense,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(width: 8),

              // Mini card Thu
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF5A9BD4).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.trending_down_rounded,
                      color: Colors.white,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      CurrencyFormatter.formatCompact(widget.totalIncome),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      background: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.cs.primary,
              context.cs.inversePrimary,
              context.cs.onPrimaryContainer,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header với title và decoration
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            context.l10n.incomeExpense,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.notifications_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Dropdown tháng này với animation và tương tác
              Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 0.8 + (0.2 * value),
                      child: Opacity(
                        opacity: value,
                        child: GestureDetector(
                          onTap: _showMonthPicker,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _getDisplayText(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                AnimatedRotation(
                                  turns: _isMonthPickerVisible ? 0.5 : 0.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: const Icon(
                                    Icons.expand_more_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Cards with smooth transition effect
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: AnimatedOpacity(
                  opacity: widget.collapseRatio > 0.3 ? widget.collapseRatio : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Transform.scale(
                    // Cards will shrink as they collapse
                    scale: 0.7 + (0.3 * widget.collapseRatio),
                    child: Row(
                      children: [
                        Expanded(
                          child: SummaryCard(
                            label: context.l10n.income,
                            amount: widget.totalIncome,
                            selected: widget.selectedFilter == FilterType.income,
                            icon: Icons.trending_up_rounded,
                            gradientStart: const Color(0xFF1E3A5F),
                            gradientEnd: const Color(0xFF2A4B73),
                            onTap: () {
                              widget.onFilterChanged(
                                widget.selectedFilter == FilterType.income
                                ? FilterType.all
                                : FilterType.income
                              );
                            },
                            collapseRatio: widget.collapseRatio,
                          ),
                        ),
                        SizedBox(width: 16 * widget.collapseRatio),
                        Expanded(
                          child: SummaryCard(
                            label: context.l10n.expense,
                            amount: widget.totalExpense,
                            selected: widget.selectedFilter == FilterType.expense,
                            icon: Icons.trending_down_rounded,
                            gradientStart: const Color(0xFF3A7BA8),
                            gradientEnd: const Color(0xFF4A8BC2),
                            onTap: () {
                              widget.onFilterChanged(
                                widget.selectedFilter == FilterType.expense
                                ? FilterType.all
                                : FilterType.expense
                              );
                            },
                            collapseRatio: widget.collapseRatio,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
