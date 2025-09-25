import 'package:expense_tracker/core/extensions/context_extensions.dart';
import 'package:expense_tracker/core/utils/localization_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../expense_tracking/domain/entities/expense.dart';
import '../../../../core/utils/formatters.dart';

class MonthlyChartCard extends StatefulWidget {
  final List<Expense> expenses;

  const MonthlyChartCard({super.key, required this.expenses});

  @override
  State<MonthlyChartCard> createState() => _MonthlyChartCardState();
}

class _MonthlyChartCardState extends State<MonthlyChartCard> {
  DateTime selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Đảm bảo selectedMonth được khởi tạo đúng
    selectedMonth = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final dailyData = _calculateDailyData();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                FaIcon(FontAwesomeIcons.chartLine, size: 18.sp),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.l10n.overview,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Month selector
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.cs.primary.withOpacity(0.1),
                    context.cs.primary.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: context.cs.primary.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.cs.primary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        selectedMonth = DateTime(
                          selectedMonth.year,
                          selectedMonth.month - 1,
                          1,
                        );
                      });
                    },
                    icon: const Icon(Icons.arrow_back_ios, size: 16),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        DateFormatter.formatMonthYear(
                          selectedMonth,
                          context.l10n.localeName,
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: context.cs.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _canGoToNextMonth()
                        ? () {
                            setState(() {
                              selectedMonth = DateTime(
                                selectedMonth.year,
                                selectedMonth.month + 1,
                                1,
                              );
                            });
                          }
                        : null,
                    icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Total for month
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.monthlyTotalExpenses,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    '${_getTotalForMonth(dailyData) >= 0 ? '+' : ''}${CurrencyFormatter.format(_getTotalForMonth(dailyData))}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getTotalForMonth(dailyData) >= 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (dailyData.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(Icons.trending_up, size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        context.l10n.noExpenses,
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              SizedBox(
                height: 280,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval: _getHorizontalInterval(dailyData),
                      verticalInterval: 5,
                      getDrawingHorizontalLine: (value) {
                        // Highlight the zero line
                        if (value == 0) {
                          return FlLine(
                            color: Colors.black.withOpacity(0.5),
                            strokeWidth: 2,
                          );
                        }
                        return FlLine(
                          color: Colors.grey.withOpacity(0.2),
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withOpacity(0.1),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 35,
                          interval: 5,
                          getTitlesWidget: (value, meta) {
                            final day = value.toInt();
                            if (day > 0 && day <= _getDaysInMonth()) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  day.toString(),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: _getHorizontalInterval(dailyData),
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                CurrencyFormatter.formatCompact(value),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                        left: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    minX: 1,
                    maxX: _getDaysInMonth().toDouble(),
                    minY: _getMinY(dailyData),
                    maxY: _getMaxY(dailyData),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _buildLineChartSpots(dailyData),
                        isCurved: true,
                        color: Theme.of(context).primaryColor,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            final value = spot.y;
                            final color = value >= 0
                                ? Colors.green
                                : Colors.red;
                            return FlDotCirclePainter(
                              radius: 4,
                              color: color,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.withOpacity(0.1),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          applyCutOffY: true,
                          cutOffY: 0,
                        ),
                        aboveBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.red.withOpacity(0.1),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          applyCutOffY: true,
                          cutOffY: 0,
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final day = spot.x.toInt();
                            final amount = spot.y;
                            final isPositive = amount >= 0;
                            final label = isPositive ? 'Thặng dư' : 'Thâm hụt';

                            return LineTooltipItem(
                              'Ngày $day\n$label: ${CurrencyFormatter.format(amount.abs())}',
                              TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            );
                          }).toList();
                        },
                      ),
                      handleBuiltInTouches: true,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Map<int, double> _calculateDailyData() {
    final Map<int, double> dailyTotals = {};
    final daysInMonth = _getDaysInMonth();

    // Initialize all days with 0
    for (int day = 1; day <= daysInMonth; day++) {
      dailyTotals[day] = 0.0;
    }

    // Calculate actual totals for selected month (income - expense)
    for (final expense in widget.expenses) {
      if (expense.date.year == selectedMonth.year &&
          expense.date.month == selectedMonth.month) {
        final day = expense.date.day;
        final amount = expense.isIncome ? expense.amount : -expense.amount;
        dailyTotals[day] = (dailyTotals[day] ?? 0) + amount;
      }
    }

    // Remove days with 0 values for cleaner chart
    return Map.fromEntries(
      dailyTotals.entries.where((entry) => entry.value != 0),
    );
  }

  List<FlSpot> _buildLineChartSpots(Map<int, double> dailyData) {
    if (dailyData.isEmpty) return [];

    return dailyData.entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();
  }

  double _getMaxY(Map<int, double> dailyData) {
    if (dailyData.values.isEmpty) return 100000;
    final maxValue = dailyData.values.reduce((a, b) => a > b ? a : b);
    return maxValue > 0
        ? maxValue * 1.2
        : maxValue.abs() * 0.2; // Add 20% padding
  }

  double _getMinY(Map<int, double> dailyData) {
    if (dailyData.values.isEmpty) return -100000;
    final minValue = dailyData.values.reduce((a, b) => a < b ? a : b);
    return minValue < 0 ? minValue * 1.2 : minValue * -0.2; // Add 20% padding
  }

  double _getHorizontalInterval(Map<int, double> dailyData) {
    final maxY = _getMaxY(dailyData);
    final minY = _getMinY(dailyData);
    final range = maxY - minY;
    return range / 6; // Divide into 6 intervals for better granularity
  }

  int _getDaysInMonth() {
    return DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;
  }

  bool _canGoToNextMonth() {
    final now = DateTime.now();
    return selectedMonth.year < now.year ||
        (selectedMonth.year == now.year && selectedMonth.month < now.month);
  }

  double _getTotalForMonth(Map<int, double> dailyData) {
    return dailyData.values.fold(0.0, (sum, amount) => sum + amount);
  }
}
