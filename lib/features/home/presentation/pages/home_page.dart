import 'package:expense_tracker/core/extensions/context_extensions.dart';
import 'package:expense_tracker/core/utils/localization_helper.dart';
import 'package:expense_tracker/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../expense_tracking/data/datasources/database_helper.dart';
import '../../../expense_tracking/domain/entities/expense.dart';
import '../../../expense_tracking/presentation/bloc/expense_bloc.dart';
import '../../../expense_tracking/presentation/bloc/expense_event.dart';
import '../../../expense_tracking/presentation/bloc/expense_state.dart';
import '../../../expense_tracking/presentation/pages/add_edit_expense_page.dart';
import '../widgets/overview_card.dart';
import '../widgets/recent_expenses_card.dart';
import '../widgets/monthly_chart_card.dart';
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
    // Ensure data is loaded when page appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpenseBloc>().add(LoadExpenses());
    });
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
        backgroundColor: context.cs.inversePrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.database),
            onPressed: () async {
              try {
                logger.i('Resetting database...');
                final dbHelper = DatabaseHelper.instance;
                await dbHelper.deleteDatabase();
                await dbHelper.database; // Recreate database with sample data
                context.read<ExpenseBloc>().add(LoadExpenses());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Database reset với sample data thành công!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                logger.e('Error resetting database: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Lỗi reset database: $e'),
                    backgroundColor: context.cs.error,
                  ),
                );
              }
            },
          ),
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
          logger.i('Current ExpenseState: $state');

          if (state is ExpenseLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ExpenseError) {
            logger.e('ExpenseError: ${state.message}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Lỗi: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ExpenseBloc>().add(LoadExpenses());
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          List<Expense> expenses = [];
          if (state is ExpenseLoaded) {
            expenses = state.expenses;
            logger.i('Loaded ${expenses.length} expenses');
          } else {
            logger.w('State is not ExpenseLoaded: $state');
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

                  // Recent expenses sorted by date (newest first), limit to 5 items
                  RecentExpensesCard(
                    expenses:
                        (expenses.toList()
                              ..sort((a, b) => b.date.compareTo(a.date)))
                            .take(5)
                            .toList(),
                    onViewAllPressed: () {
                      // Navigate to expense list - implement later
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Navigate to expenses list'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Monthly Chart
                  MonthlyChartCard(expenses: expenses),
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
              child: FaIcon(icon, color: color, size: 22.sp),
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
