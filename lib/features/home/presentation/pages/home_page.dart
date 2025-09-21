import 'package:expense_tracker/core/utils/localization_helper.dart';
import 'package:expense_tracker/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../expense_tracking/domain/entities/expense.dart';
import '../../../expense_tracking/presentation/bloc/expense_bloc.dart';
import '../../../expense_tracking/presentation/bloc/expense_event.dart';
import '../../../expense_tracking/presentation/bloc/expense_state.dart';
import '../../../expense_tracking/presentation/pages/add_edit_expense_page.dart';
import '../widgets/overview_card.dart';
import '../widgets/recent_expenses_card.dart';
import '../../../../core/utils/formatters.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load expenses for overview
    context.read<ExpenseBloc>().add(LoadExpenses());
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.hello,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.normal),
            ),
            Text(
              DateFormatter.formatFullDate(now, context.l10n.localeName),
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.bell),
            onPressed: () {
              // TODO: Implement notifications
              logger.i(context.l10n.localeName);
            },
          ),
        ],
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Expense> expenses = [];
          if (state is ExpenseLoaded) {
            expenses = state.expenses;
          }

          // Calculate today's expenses
          final todayExpenses = expenses.where((expense) {
            return expense.date.year == today.year &&
                expense.date.month == today.month &&
                expense.date.day == today.day;
          }).toList();

          // Calculate this month's expenses
          final monthExpenses = expenses.where((expense) {
            return expense.date.isAfter(
                  startOfMonth.subtract(const Duration(days: 1)),
                ) &&
                expense.date.isBefore(endOfMonth.add(const Duration(days: 1)));
          }).toList();

          final todayTotal = todayExpenses.fold<double>(
            0.0,
            (sum, expense) => sum + expense.amount,
          );
          final monthTotal = monthExpenses.fold<double>(
            0.0,
            (sum, expense) => sum + expense.amount,
          );
          final totalExpenses = expenses.fold<double>(
            0.0,
            (sum, expense) => sum + expense.amount,
          );

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ExpenseBloc>().add(LoadExpenses());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Overview
                  OverviewCard(
                    totalExpenses: totalExpenses,
                    todayExpenses: todayTotal,
                    monthExpenses: monthTotal,
                    transactionCount: expenses.length,
                    balance: 0.0, // TODO: Implement balance calculation
                  ),

                  const SizedBox(height: 20),

                  // Quick Actions
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.quickActions,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildQuickAction(
                                context,
                                icon: FontAwesomeIcons.plus,
                                label: context.l10n.addExpense,
                                color: Colors.red,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AddEditExpensePage(),
                                    ),
                                  );
                                },
                              ),
                              _buildQuickAction(
                                context,
                                icon: FontAwesomeIcons.chartPie,
                                label: context.l10n.viewStatistics,
                                color: Colors.purple,
                                onTap: () {
                                  // TODO: Navigate to statistics
                                },
                              ),
                              _buildQuickAction(
                                context,
                                icon: FontAwesomeIcons.listUl,
                                label: context.l10n.list,
                                color: Colors.orange,
                                onTap: () {
                                  // TODO: Navigate to expenses list
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  RecentExpensesCard(expenses: expenses.take(5).toList()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: FaIcon(icon, color: color, size: 20.sp),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
