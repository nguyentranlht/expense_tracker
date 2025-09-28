import 'package:expense_tracker/core/utils/localization_helper.dart';
import 'package:expense_tracker/features/expense_tracking/presentation/widgets/expense_flexible_bar.dart';
import 'package:expense_tracker/widgets/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../widgets/expense_card.dart';
import 'add_edit_expense_page.dart';

class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({super.key});

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  FilterType _currentFilter = FilterType.all;
  DateTime? _selectedMonth;
  bool _showAllMonths = true;

  @override
  void initState() {
    super.initState();
    // Load expenses when page is initialized
    context.read<ExpenseBloc>().add(LoadExpenses());
  }

  List<dynamic> _filterExpensesByMonth(List<dynamic> expenses) {
    if (_showAllMonths || _selectedMonth == null) {
      return expenses;
    }
    return expenses.where((expense) {
      final expenseDate = expense.date;
      return expenseDate.year == _selectedMonth!.year &&
          expenseDate.month == _selectedMonth!.month;
    }).toList();
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
            if (state.expenses.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Chưa có giao dịch nào',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Nhấn nút + để thêm thu nhập hoặc chi tiêu',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            // Filter expenses by month first
            final monthFilteredExpenses = _filterExpensesByMonth(
              state.expenses,
            );

            // Calculate totals for the selected month
            final totalIncome = monthFilteredExpenses.fold<double>(
              0.0,
              (sum, expense) => expense.isIncome ? sum + expense.amount : sum,
            );

            final totalExpense = monthFilteredExpenses.fold<double>(
              0.0,
              (sum, expense) => !expense.isIncome ? sum + expense.amount : sum,
            );

            // Filter expenses based on selected filter
            final filteredExpenses = monthFilteredExpenses.where((expense) {
              switch (_currentFilter) {
                case FilterType.expense:
                  return !expense.isIncome;
                case FilterType.income:
                  return expense.isIncome;
                case FilterType.all:
                  return true;
              }
            }).toList();

            return CustomScrollView(
              slivers: [
                // SliverAppBar với behavior ẩn/hiện
                SliverAppBar(
                  expandedHeight: 300.h,
                  pinned: true,
                  elevation: 0,
                  forceElevated: false,
                  flexibleSpace: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      // Tính toán tỷ lệ collapse (0.0 = collapsed, 1.0 = expanded)
                      final expandedHeight = 300.0;
                      final currentHeight = constraints.maxHeight;
                      final minHeight =
                          kToolbarHeight + MediaQuery.of(context).padding.top;
                      final collapseRatio =
                          ((currentHeight - minHeight) /
                                  (expandedHeight - minHeight))
                              .clamp(0.0, 1.0);
                      final isCollapsed = collapseRatio < 0.3;

                      return ExpenseFlexibleBar(
                        isCollapsed: isCollapsed,
                        collapseRatio: collapseRatio,
                        totalIncome: totalIncome,
                        totalExpense: totalExpense,
                        selectedFilter: _currentFilter,
                        selectedMonth: _selectedMonth,
                        showAllMonths: _showAllMonths,
                        onFilterChanged: (filter) {
                          setState(() {
                            _currentFilter = filter;
                          });
                        },
                        onMonthChanged: (month) {
                          setState(() {
                            _selectedMonth = month;
                          });
                        },
                        onShowAllChanged: (showAll) {
                          setState(() {
                            _showAllMonths = showAll;
                          });
                        },
                      );
                    },
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final expense = filteredExpenses[index];
                      return ExpenseCard(
                        expense: expense,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddEditExpensePage(expense: expense),
                            ),
                          );
                        },
                        onDelete: () {
                          AppDialog.confirm(
                            context: context,
                            title: context.l10n.deleteConfirmTitle,
                            content: context.l10n.deleteConfirmContent,
                            cancelText: context.l10n.back,
                            confirmText: context.l10n.delete,
                            confirmColor: Colors.red,
                            onConfirm: () {
                              context.read<ExpenseBloc>().add(
                                DeleteExpenseEvent(expense.id!),
                              );
                            },
                          );
                        },
                      );
                    },
                    childCount: filteredExpenses.length,
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddEditExpensePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
