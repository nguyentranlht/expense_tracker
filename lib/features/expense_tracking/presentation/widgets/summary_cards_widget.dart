import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/formatters.dart';

class SummaryCardsWidget extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;
  final double netAmount;
  final int totalTransactions;

  const SummaryCardsWidget({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
    required this.netAmount,
    required this.totalTransactions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hàng đầu: Thu nhập và Chi tiêu
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
        // Hàng thứ hai: Số dư và Giao dịch
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
      ],
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