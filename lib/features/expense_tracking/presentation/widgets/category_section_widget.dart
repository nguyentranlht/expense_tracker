import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/formatters.dart';

class CategorySectionWidget extends StatelessWidget {
  final List<MapEntry<String, double>> sortedCategories;
  final Map<String, int> categoryCounts;
  final double totalAmount;
  final bool isIncome;
  final String title;
  final IconData icon;

  const CategorySectionWidget({
    super.key,
    required this.sortedCategories,
    required this.categoryCounts,
    required this.totalAmount,
    required this.isIncome,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (sortedCategories.isEmpty) return const SizedBox.shrink();

    final color = isIncome ? Colors.green : Colors.red;
    final bgColor1 = isIncome ? Colors.green : Colors.red;
    final bgColor2 = isIncome ? Colors.teal : Colors.orange;

    return Column(
      children: [
        // Header với icon và title
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
                bgColor1.withOpacity(0.1),
                bgColor2.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: color[600],
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                title,
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

        // Danh sách category cards
        ...sortedCategories.map((entry) {
          final category = entry.key;
          final amount = entry.value;
          final count = categoryCounts[category] ?? 0;
          final percentage = totalAmount > 0
              ? (amount / totalAmount * 100).toDouble()
              : 0.0;

          return _buildCategoryCard(
            category,
            amount,
            count,
            percentage,
            isIncome,
          );
        }),

        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildCategoryCard(
    String category,
    double amount,
    int count,
    double percentage,
    bool isIncome,
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
}