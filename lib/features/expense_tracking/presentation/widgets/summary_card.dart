import 'package:expense_tracker/core/utils/formatters.dart';
import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String label;
  final double amount;
  final bool selected;
  final IconData icon;
  final Color gradientStart;
  final Color gradientEnd;
  final VoidCallback onTap;
  final double collapseRatio;

  const SummaryCard({
    super.key,
    required this.label,
    required this.amount,
    required this.selected,
    required this.icon,
    required this.gradientStart,
    required this.gradientEnd,
    required this.onTap,
    required this.collapseRatio,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(18 * collapseRatio.clamp(0.5, 1.0)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: selected
                ? [gradientStart, gradientEnd]
                : [gradientStart.withOpacity(0.7), gradientEnd.withOpacity(0.7)],
          ),
          borderRadius: BorderRadius.circular(16 * collapseRatio.clamp(0.7, 1.0)),
          border: selected ? Border.all(color: Colors.white, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: gradientStart.withOpacity(selected ? 0.4 : 0.3),
              blurRadius: 12 * collapseRatio,
              offset: Offset(0, 6 * collapseRatio),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white.withOpacity(0.9),
                  size: (18 * collapseRatio).clamp(12.0, 18.0),
                ),
                SizedBox(width: 6 * collapseRatio),
                Text(
                  collapseRatio > 0.6 ? label : label.substring(0, 3),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: (14 * collapseRatio).clamp(10.0, 14.0),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                const Spacer(),
                if (selected)
                  AnimatedScale(
                    scale: selected ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: (18 * collapseRatio).clamp(12.0, 18.0),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12 * collapseRatio),
            FittedBox(
              child: Text(
                collapseRatio > 0.6
                    ? CurrencyFormatter.format(amount)
                    : CurrencyFormatter.formatCompact(amount),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: (22 * collapseRatio).clamp(12.0, 22.0),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}