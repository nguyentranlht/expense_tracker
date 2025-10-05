import 'package:expense_tracker/core/extensions/context_extensions.dart';
import 'package:expense_tracker/core/utils/formatters.dart';
import 'package:expense_tracker/core/utils/localization_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../widgets/statistics_flexinle_bar.dart';

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
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long,
                              size: 80.sp,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 24.h),
                            Text(
                              context.l10n.noExpenses,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              context.l10n.addTransactionHint,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Calculate statistics - phân biệt thu nhập và chi tiêu
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Summary cards với thu nhập, chi tiêu và số dư
                        Row(
                          children: [
                            Expanded(
                              child: _buildSummaryCard(
                                'Thu nhập',
                                CurrencyFormatter.format(totalIncome),
                                Icons.trending_up,
                                Colors.green,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildSummaryCard(
                                'Chi tiêu',
                                CurrencyFormatter.format(totalExpense),
                                Icons.trending_down,
                                Colors.red,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSummaryCard(
                                'Số dư',
                                CurrencyFormatter.format(netAmount),
                                netAmount >= 0 ? Icons.savings : Icons.warning,
                                netAmount >= 0 ? Colors.blue : Colors.orange,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildSummaryCard(
                                'Giao dịch',
                                totalTransactions.toString(),
                                Icons.receipt_long,
                                Colors.purple,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 32.h),

                        // Thu nhập theo danh mục
                        if (sortedIncomeCategories.isNotEmpty) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.green.withOpacity(0.1),
                                  Colors.teal.withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.trending_up,
                                  color: Colors.green[600],
                                  size: 24.sp,
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  'Thu nhập theo danh mục',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),

                          ...sortedIncomeCategories.map((entry) {
                            final category = entry.key;
                            final amount = entry.value;
                            final count = incomeCategoryCounts[category] ?? 0;
                            final percentage = totalIncome > 0
                                ? (amount / totalIncome * 100).toDouble()
                                : 0.0;

                            return _buildCategoryCard(
                              category,
                              amount,
                              count,
                              percentage,
                              true,
                              context,
                            );
                          }),

                          SizedBox(height: 24.h),
                        ],

                        // Chi tiêu theo danh mục
                        if (sortedExpenseCategories.isNotEmpty) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.red.withOpacity(0.1),
                                  Colors.orange.withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.trending_down,
                                  color: Colors.red[600],
                                  size: 24.sp,
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  'Chi tiêu theo danh mục',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),

                          ...sortedExpenseCategories.map((entry) {
                            final category = entry.key;
                            final amount = entry.value;
                            final count = expenseCategoryCounts[category] ?? 0;
                            final percentage = totalExpense > 0
                                ? (amount / totalExpense * 100).toDouble()
                                : 0.0;

                            return _buildCategoryCard(
                              category,
                              amount,
                              count,
                              percentage,
                              false,
                              context,
                            );
                          }),
                        ],
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

  Widget _buildCategoryCard(
    String category,
    double amount,
    int count,
    double percentage,
    bool isIncome,
    BuildContext context,
  ) {
    final color = isIncome ? Colors.green : Colors.red;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, color.withOpacity(0.02)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        isIncome ? Icons.add_circle : Icons.remove_circle,
                        color: color,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          category,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '${isIncome ? '+' : '-'}${CurrencyFormatter.format(amount)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                      color: color[600],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$count giao dịch',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: color[700],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6.h,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: color, size: 28.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  
}
