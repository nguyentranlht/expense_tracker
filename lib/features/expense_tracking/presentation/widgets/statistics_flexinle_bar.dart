import 'package:expense_tracker/core/extensions/context_extensions.dart';
import 'package:expense_tracker/core/utils/formatters.dart';
import 'package:expense_tracker/core/utils/localization_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatisticsFlexibleBar extends StatefulWidget {
  final bool isCollapsed;
  final DateTime startDate;
  final DateTime endDate;
  final VoidCallback? onLoadStatistics;
  final Function(DateTime, DateTime)? onDateRangeChanged;

  const StatisticsFlexibleBar({
    super.key,
    required this.isCollapsed,
    required this.startDate,
    required this.endDate,
    this.onLoadStatistics,
    this.onDateRangeChanged,
  });

  @override
  State<StatisticsFlexibleBar> createState() => _StatisticsFlexibleBarState();
}

class _StatisticsFlexibleBarState extends State<StatisticsFlexibleBar> {
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  void _loadStatistics() {
    // Also call the onLoadStatistics callback if provided
    widget.onLoadStatistics?.call();
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
              Text(
                context.l10n.statisticsTitle,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      background: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.statisticsTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.grey[50]!],
                ),
                borderRadius: BorderRadius.circular(20.r),
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
                    Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          color: context.cs.primary,
                          size: 24.sp,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Chọn khoảng thời gian',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateSelector(
                            context: context,
                            label: context.l10n.fromDate,
                            date: _startDate,
                            onTap: () => _selectDate(true),
                            backgroundColor: Colors.blue[50]!,
                            borderColor: Colors.blue[200]!,
                            labelColor: Colors.blue[600]!,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: _buildDateSelector(
                            context: context,
                            label: context.l10n.toDate,
                            date: _endDate,
                            onTap: () => _selectDate(false),
                            backgroundColor: Colors.orange[50]!,
                            borderColor: Colors.orange[200]!,
                            labelColor: Colors.orange[600]!,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            context.cs.primary,
                            context.cs.primary.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: context.cs.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _loadStatistics,
                          borderRadius: BorderRadius.circular(12.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Cập nhật thống kê',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector({
    required BuildContext context,
    required String label,
    required DateTime date,
    required VoidCallback onTap,
    required Color backgroundColor,
    required Color borderColor,
    required Color labelColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: labelColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                DateFormatter.formatDate(
                  date,
                  Localizations.localeOf(context).languageCode,
                ),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(bool isStartDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: isStartDate ? DateTime(2020) : _startDate,
      lastDate: isStartDate ? _endDate : DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
      // Notify parent widget about date range change
      widget.onDateRangeChanged?.call(_startDate, _endDate);
    }
  }
}
