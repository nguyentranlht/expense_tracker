import 'package:expense_tracker/core/extensions/context_extensions.dart';
import 'package:expense_tracker/core/utils/formatters.dart';
import 'package:expense_tracker/core/utils/localization_helper.dart';
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
  String _selectedFilter = 'Tất cả'; // 'Tất cả', 'Chi tiêu', 'Thu nhập'
  DateTime _selectedMonth = DateTime.now();
  bool _isMonthPickerVisible = false;

  @override
  void initState() {
    super.initState();
    // Load expenses when page is initialized
    context.read<ExpenseBloc>().add(LoadExpenses());
  }

  List<dynamic> _filterExpensesByMonth(List<dynamic> expenses) {
    return expenses.where((expense) {
      final expenseDate = expense.date;
      return expenseDate.year == _selectedMonth.year && 
             expenseDate.month == _selectedMonth.month;
    }).toList();
  }

  void _showMonthPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 300,
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
                    final monthDate = DateTime(_selectedMonth.year, month);
                    final isSelected = monthDate.month == _selectedMonth.month;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMonth = DateTime(_selectedMonth.year, month);
                        });
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
      },
    );
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
            final monthFilteredExpenses = _filterExpensesByMonth(state.expenses);
            
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
              switch (_selectedFilter) {
                case 'Chi tiêu':
                  return !expense.isIncome;
                case 'Thu nhập':
                  return expense.isIncome;
                default:
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
                      final minHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
                      final collapseRatio = ((currentHeight - minHeight) / (expandedHeight - minHeight)).clamp(0.0, 1.0);
                      final isCollapsed = collapseRatio < 0.3;

                      return FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        centerTitle: true,
                        title: AnimatedOpacity(
                          opacity: isCollapsed ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Mini card Chi
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
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
                                        CurrencyFormatter.formatCompact(totalExpense),
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
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
                                        CurrencyFormatter.formatCompact(totalIncome),
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(
                                              25,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(
                                                0.3,
                                              ),
                                              width: 1,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.1,
                                                ),
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
                                                DateFormatter.formatMonthYear(_selectedMonth, context.l10n.localeName),
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
                                opacity: collapseRatio > 0.3 ? collapseRatio : 0.0,
                                duration: const Duration(milliseconds: 300),
                                child: Transform.scale(
                                  // Cards will shrink as they collapse
                                  scale: 0.7 + (0.3 * collapseRatio),
                                  child: Row(
                                    children: [
                                      // Tiền chi card with smooth transition
                                      Expanded(
                                        child: TweenAnimationBuilder<double>(
                                          tween: Tween(begin: 0.0, end: 1.0),
                                          duration: const Duration(
                                            milliseconds: 600,
                                          ),
                                          builder: (context, value, child) {
                                            return Transform.translate(
                                              offset: Offset(-50 * (1 - value), 0),
                                              child: Opacity(
                                                opacity: value,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedFilter =
                                                          _selectedFilter ==
                                                              'Chi tiêu'
                                                          ? 'Tất cả'
                                                          : 'Chi tiêu';
                                                    });
                                                  },
                                                  child: AnimatedContainer(
                                                    duration: const Duration(
                                                      milliseconds: 300,
                                                    ),
                                                    curve: Curves.easeInOut,
                                                    padding: EdgeInsets.all(18 * collapseRatio.clamp(0.5, 1.0)),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                        colors:
                                                            _selectedFilter ==
                                                                'Chi tiêu'
                                                            ? [
                                                                const Color(
                                                                  0xFF1E3A5F,
                                                                ),
                                                                const Color(
                                                                  0xFF2A4B73,
                                                                ),
                                                              ]
                                                            : [
                                                                const Color(
                                                                  0xFF2E5C8A,
                                                                ),
                                                                const Color(
                                                                  0xFF4A7BA7,
                                                                ),
                                                              ],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(16 * collapseRatio.clamp(0.7, 1.0)),
                                                      border:
                                                          _selectedFilter ==
                                                              'Chi tiêu'
                                                          ? Border.all(
                                                              color: Colors.white,
                                                              width: 2,
                                                            )
                                                          : null,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              _selectedFilter ==
                                                                  'Chi tiêu'
                                                              ? const Color(
                                                                  0xFF1E3A5F,
                                                                ).withOpacity(0.4)
                                                              : const Color(
                                                                  0xFF2E5C8A,
                                                                ).withOpacity(0.3),
                                                          blurRadius: 12 * collapseRatio,
                                                          offset: Offset(
                                                            0,
                                                            6 * collapseRatio,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .trending_up_rounded,
                                                              color: Colors.white
                                                                  .withOpacity(0.9),
                                                              size: (18 * collapseRatio).clamp(12.0, 18.0),
                                                            ),
                                                            SizedBox(
                                                              width: 6 * collapseRatio,
                                                            ),
                                                            Text(
                                                              collapseRatio > 0.6 ? 'Tiền chi' : 'Chi',
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: (14 * collapseRatio).clamp(10.0, 14.0),
                                                                fontWeight:
                                                                    FontWeight.w500,
                                                                letterSpacing: 0.3,
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            if (_selectedFilter ==
                                                                'Chi tiêu')
                                                              AnimatedScale(
                                                                scale:
                                                                    _selectedFilter ==
                                                                        'Chi tiêu'
                                                                    ? 1.0
                                                                    : 0.0,
                                                                duration:
                                                                    const Duration(
                                                                      milliseconds:
                                                                          200,
                                                                    ),
                                                                child: Icon(
                                                                  Icons
                                                                      .check_circle_rounded,
                                                                  color:
                                                                      Colors.white,
                                                                  size: (18 * collapseRatio).clamp(12.0, 18.0),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 12 * collapseRatio),
                                                        FittedBox(
                                                          child: Text(
                                                            collapseRatio > 0.6 
                                                                ? CurrencyFormatter.format(totalExpense)
                                                                : CurrencyFormatter.formatCompact(totalExpense),
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: (22 * collapseRatio).clamp(12.0, 22.0),
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              letterSpacing: 0.5,
                                                            ),
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

                                      SizedBox(width: 16 * collapseRatio),

                                      // Tiền thu card with smooth transition
                                      Expanded(
                                        child: TweenAnimationBuilder<double>(
                                          tween: Tween(begin: 0.0, end: 1.0),
                                          duration: const Duration(
                                            milliseconds: 800,
                                          ),
                                          builder: (context, value, child) {
                                            return Transform.translate(
                                              offset: Offset(50 * (1 - value), 0),
                                              child: Opacity(
                                                opacity: value,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedFilter =
                                                          _selectedFilter ==
                                                              'Thu nhập'
                                                          ? 'Tất cả'
                                                          : 'Thu nhập';
                                                    });
                                                  },
                                                  child: AnimatedContainer(
                                                    duration: const Duration(
                                                      milliseconds: 300,
                                                    ),
                                                    curve: Curves.easeInOut,
                                                    padding: EdgeInsets.all(18 * collapseRatio.clamp(0.5, 1.0)),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                        colors:
                                                            _selectedFilter ==
                                                                'Thu nhập'
                                                            ? [
                                                                const Color(
                                                                  0xFF3A7BA8,
                                                                ),
                                                                const Color(
                                                                  0xFF4A8BC2,
                                                                ),
                                                              ]
                                                            : [
                                                                const Color(
                                                                  0xFF5A9BD4,
                                                                ),
                                                                const Color(
                                                                  0xFF6BADDE,
                                                                ),
                                                              ],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(16 * collapseRatio.clamp(0.7, 1.0)),
                                                      border:
                                                          _selectedFilter ==
                                                              'Thu nhập'
                                                          ? Border.all(
                                                              color: Colors.white,
                                                              width: 2,
                                                            )
                                                          : null,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              _selectedFilter ==
                                                                  'Thu nhập'
                                                              ? const Color(
                                                                  0xFF3A7BA8,
                                                                ).withOpacity(0.4)
                                                              : const Color(
                                                                  0xFF5A9BD4,
                                                                ).withOpacity(0.3),
                                                          blurRadius: 12 * collapseRatio,
                                                          offset: Offset(
                                                            0,
                                                            6 * collapseRatio,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .trending_down_rounded,
                                                              color: Colors.white
                                                                  .withOpacity(0.9),
                                                              size: (18 * collapseRatio).clamp(12.0, 18.0),
                                                            ),
                                                            SizedBox(
                                                              width: 6 * collapseRatio,
                                                            ),
                                                            Text(
                                                              collapseRatio > 0.6 ? 'Tiền thu' : 'Thu',
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: (14 * collapseRatio).clamp(10.0, 14.0),
                                                                fontWeight:
                                                                    FontWeight.w500,
                                                                letterSpacing: 0.3,
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            if (_selectedFilter ==
                                                                'Thu nhập')
                                                              AnimatedScale(
                                                                scale:
                                                                    _selectedFilter ==
                                                                        'Thu nhập'
                                                                    ? 1.0
                                                                    : 0.0,
                                                                duration:
                                                                    const Duration(
                                                                      milliseconds:
                                                                          200,
                                                                    ),
                                                                child: Icon(
                                                                  Icons
                                                                      .check_circle_rounded,
                                                                  color:
                                                                      Colors.white,
                                                                  size: (18 * collapseRatio).clamp(12.0, 18.0),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 12 * collapseRatio),
                                                        FittedBox(
                                                          child: Text(
                                                            collapseRatio > 0.6 
                                                                ? CurrencyFormatter.format(totalIncome)
                                                                : CurrencyFormatter.formatCompact(totalIncome),
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: (22 * collapseRatio).clamp(12.0, 22.0),
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              letterSpacing: 0.5,
                                                            ),
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
                    },
                  ),
                  backgroundColor: context.cs.primary,
                ),

                // Expenses list
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final expense = filteredExpenses[index];
                    return ExpenseCard(
                      expense: expense,
                      onEdit: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                AddEditExpensePage(expense: expense),
                          ),
                        );
                      },
                      onDelete: () {
                        _showDeleteConfirmDialog(context, expense.id!);
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

  void _showDeleteConfirmDialog(BuildContext context, int expenseId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa giao dịch này?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                context.read<ExpenseBloc>().add(DeleteExpenseEvent(expenseId));
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }
}
