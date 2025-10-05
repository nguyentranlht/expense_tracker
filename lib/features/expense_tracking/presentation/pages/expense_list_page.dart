import 'package:expense_tracker/core/extensions/context_extensions.dart';
import 'package:expense_tracker/core/utils/localization_helper.dart';
import 'package:expense_tracker/features/expense_tracking/presentation/widgets/expense_flexible_bar.dart';
import 'package:expense_tracker/widgets/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  bool _isFabExpanded = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load expenses when page is initialized
    context.read<ExpenseBloc>().add(LoadExpenses());

    // Listen to scroll changes
    _scrollController.addListener(_onScroll);
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
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final expense = filteredExpenses[index];
                    return ExpenseCard(
                      expense: expense,
                      onDetail: true,
                      onEdit: () {
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
                  }, childCount: filteredExpenses.length),
                ),
              ],
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(
          bottom: _isFabExpanded ? MediaQuery.of(context).padding.bottom : 8.r,
          right: 8.r,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_isFabExpanded ? 20 : 16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4285f4), // Gmail blue
              Color(0xFF1a73e8), // Darker Gmail blue
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4285f4).withOpacity(0.3),
              blurRadius: _isFabExpanded ? 15 : 10,
              offset: Offset(0, _isFabExpanded ? 6 : 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: _isFabExpanded ? 8 : 6,
              offset: Offset(0, _isFabExpanded ? 2 : 1),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(_isFabExpanded ? 20 : 16),
          child: InkWell(
            borderRadius: BorderRadius.circular(_isFabExpanded ? 20 : 16),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddEditExpensePage(),
                ),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              constraints: BoxConstraints(minHeight: 48.r, maxHeight: 48.r),
              padding: EdgeInsets.symmetric(
                horizontal: _isFabExpanded ? 20 : 16,
                vertical: 12, // Fixed vertical padding
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.add, color: Colors.white, size: 24),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: _isFabExpanded ? 10 : 0,
                  ),
                  AnimatedOpacity(
                    opacity: _isFabExpanded ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: _isFabExpanded ? null : 0,
                      child: Text(
                        context.l10n.addNew,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
