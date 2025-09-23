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

  const MonthlyChartCard({
    super.key,
    required this.expenses,
  });

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
    final monthName = _getMonthName(selectedMonth.month);

    return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.chartLine,
                  size: 18.sp,
                ),
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
                        '$monthName ${selectedMonth.year}',
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
                    onPressed: _canGoToNextMonth() ? () {
                      setState(() {
                        selectedMonth = DateTime(
                          selectedMonth.year,
                          selectedMonth.month + 1,
                          1,
                        );
                      });
                    } : null,
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
                    CurrencyFormatter.format(_getTotalForMonth(dailyData)),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).primaryColor,
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
                    minY: 0,
                    maxY: _getMaxY(dailyData),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _buildLineChartSpots(dailyData),
                        isCurved: true,
                        color: Theme.of(context).primaryColor,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(
                          show: true,
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
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
                            return LineTooltipItem(
                              'Ngày $day\n${CurrencyFormatter.format(amount)}',
                              const TextStyle(
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
              
            const SizedBox(height: 16),
            
            // Summary stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Ngày chi nhiều nhất',
                    _getMaxDayInfo(dailyData),
                    Icons.trending_up,
                    context.cs.error,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Trung bình/ngày',
                    CurrencyFormatter.format(_getAveragePerDay(dailyData)),
                    Icons.analytics,
                    context.cs.primary,
                  ),
                ),
              ],
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

    // Calculate actual totals for selected month
    for (final expense in widget.expenses) {
      if (expense.date.year == selectedMonth.year && 
          expense.date.month == selectedMonth.month) {
        final day = expense.date.day;
        dailyTotals[day] = (dailyTotals[day] ?? 0) + expense.amount;
      }
    }

    // Remove days with 0 values for cleaner chart
    return Map.fromEntries(
      dailyTotals.entries.where((entry) => entry.value > 0)
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
    return maxValue * 1.1; // Add 10% padding
  }

  double _getHorizontalInterval(Map<int, double> dailyData) {
    final maxY = _getMaxY(dailyData);
    return maxY / 4; // Divide into 4 intervals
  }

  int _getDaysInMonth() {
    return DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;
  }

  String _getMonthName(int month) {
    const monthNames = [
      '', 'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
      'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'
    ];
    return monthNames[month];
  }

  bool _canGoToNextMonth() {
    final now = DateTime.now();
    return selectedMonth.year < now.year || 
           (selectedMonth.year == now.year && selectedMonth.month < now.month);
  }

  double _getTotalForMonth(Map<int, double> dailyData) {
    return dailyData.values.fold(0.0, (sum, amount) => sum + amount);
  }

  String _getMaxDayInfo(Map<int, double> dailyData) {
    if (dailyData.isEmpty) return 'Không có';
    
    final maxEntry = dailyData.entries.reduce(
      (a, b) => a.value > b.value ? a : b
    );
    
    return 'Ngày ${maxEntry.key}\n${CurrencyFormatter.formatCompact(maxEntry.value)}';
  }

  double _getAveragePerDay(Map<int, double> dailyData) {
    if (dailyData.isEmpty) return 0.0;
    
    final total = _getTotalForMonth(dailyData);
    final daysWithExpenses = dailyData.length;
    
    return total / daysWithExpenses;
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14.w, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 10.w,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.w,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}