import 'package:expense_tracker/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../widgets/statistics_flexinle_bar.dart';
import '../widgets/summary_cards_widget.dart';
import '../widgets/category_section_widget.dart';
import '../widgets/empty_statistics_widget.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  DateTime _appliedStartDate = DateTime.now().subtract(
    const Duration(days: 30),
  );
  DateTime _appliedEndDate = DateTime.now();
  bool _hasUserAppliedFilter = false; // Flag để kiểm tra user đã bấm nút chưa
  bool _isFabExpanded = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load tất cả expenses một lần duy nhất
    context.read<ExpenseBloc>().add(LoadExpenses());
  }

  void _loadStatistics() {
    // Thay vì gửi event, chỉ cần setState để trigger rebuild UI
    setState(() {
      _appliedStartDate = _startDate;
      _appliedEndDate = _endDate;
      _hasUserAppliedFilter = true; // Đánh dấu user đã bấm nút
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels > 50) {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        // Scrolling down - collapse FAB
        if (_isFabExpanded) {
          setState(() {
            _isFabExpanded = false;
          });
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        // Scrolling up - expand FAB
        if (!_isFabExpanded) {
          setState(() {
            _isFabExpanded = true;
          });
        }
      }
    } else {
      // Near the top - always expanded
      if (!_isFabExpanded) {
        setState(() {
          _isFabExpanded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state is ExpenseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExpenseLoaded) {
            final filteredExpenses = _hasUserAppliedFilter
                ? state.expenses.where((expense) {
                    final expenseDate = expense.date;
                    return expenseDate.isAfter(
                          _appliedStartDate.subtract(const Duration(days: 1)),
                        ) &&
                        expenseDate.isBefore(
                          _appliedEndDate.add(const Duration(days: 1)),
                        );
                  }).toList()
                : state.expenses; // Hiển thị tất cả nếu chưa áp dụng filter

            final expenses = filteredExpenses;
            final totalIncome = expenses.fold<double>(
              0.0,
              (sum, expense) => expense.isIncome ? sum + expense.amount : sum,
            );
            final totalExpense = expenses.fold<double>(
              0.0,
              (sum, expense) => !expense.isIncome ? sum + expense.amount : sum,
            );
            final netAmount = totalIncome - totalExpense;
            final totalTransactions = expenses.length;

            // Group by category - phân biệt thu nhập và chi tiêu
            final Map<String, double> incomeCategoryTotals = {};
            final Map<String, double> expenseCategoryTotals = {};
            final Map<String, int> incomeCategoryCounts = {};
            final Map<String, int> expenseCategoryCounts = {};

            for (final expense in expenses) {
              if (expense.isIncome) {
                incomeCategoryTotals[expense.category] =
                    (incomeCategoryTotals[expense.category] ?? 0) +
                    expense.amount;
                incomeCategoryCounts[expense.category] =
                    (incomeCategoryCounts[expense.category] ?? 0) + 1;
              } else {
                expenseCategoryTotals[expense.category] =
                    (expenseCategoryTotals[expense.category] ?? 0) +
                    expense.amount;
                expenseCategoryCounts[expense.category] =
                    (expenseCategoryCounts[expense.category] ?? 0) + 1;
              }
            }

            // Sort categories by total amount
            final sortedIncomeCategories = incomeCategoryTotals.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));
            final sortedExpenseCategories =
                expenseCategoryTotals.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value));
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                // SliverAppBar với behavior ẩn/hiện
                SliverAppBar(
                  expandedHeight: 280.h,
                  pinned: true,
                  elevation: 0,
                  forceElevated: false,
                  backgroundColor: context.cs.primary,
                  flexibleSpace: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      // Tính toán tỷ lệ collapse (0.0 = collapsed, 1.0 = expanded)
                      final expandedHeight = 280.h;
                      final currentHeight = constraints.maxHeight;
                      final minHeight =
                          kToolbarHeight + MediaQuery.of(context).padding.top;
                      final collapseRatio =
                          ((currentHeight - minHeight) /
                                  (expandedHeight - minHeight))
                              .clamp(0.0, 1.0);
                      final isCollapsed = collapseRatio < 0.3;

                      return StatisticsFlexibleBar(
                        isCollapsed: isCollapsed,
                        startDate: _startDate,
                        endDate: _endDate,
                        onLoadStatistics: _loadStatistics,
                        onDateRangeChanged: (startDate, endDate) {
                          setState(() {
                            _startDate = startDate;
                            _endDate = endDate;
                          });
                        },
                      );
                    },
                  ),
                ),
                if (state.expenses.isEmpty)
                  const SliverToBoxAdapter(
                    child: EmptyStatisticsWidget(),
                  ),

                // Calculate statistics - phân biệt thu nhập và chi tiêu
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Summary cards với thu nhập, chi tiêu và số dư
                        SummaryCardsWidget(
                          totalIncome: totalIncome,
                          totalExpense: totalExpense,
                          netAmount: netAmount,
                          totalTransactions: totalTransactions,
                        ),

                        SizedBox(height: 32.h),

                        // Thu nhập theo danh mục
                        CategorySectionWidget(
                          sortedCategories: sortedIncomeCategories,
                          categoryCounts: incomeCategoryCounts,
                          totalAmount: totalIncome,
                          isIncome: true,
                          title: 'Thu nhập theo danh mục',
                          icon: Icons.trending_up,
                        ),

                        // Chi tiêu theo danh mục
                        CategorySectionWidget(
                          sortedCategories: sortedExpenseCategories,
                          categoryCounts: expenseCategoryCounts,
                          totalAmount: totalExpense,
                          isIncome: false,
                          title: 'Chi tiêu theo danh mục',
                          icon: Icons.trending_down,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (state is ExpenseError) {
            return Center(child: Text('Lỗi: ${state.message}'));
          }

          return const Center(child: Text('Không có dữ liệu'));
        },
      ),
    );
  }
}
