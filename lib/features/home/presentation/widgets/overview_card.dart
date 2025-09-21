import 'package:expense_tracker/core/utils/localization_helper.dart';
import 'package:expense_tracker/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/models/weather.dart';
import '../../../../core/services/weather_service.dart';

class OverviewCard extends StatefulWidget {
  final double totalExpenses;
  final double todayExpenses;
  final double monthExpenses;
  final int transactionCount;
  final double balance; // Thêm số dư

  const OverviewCard({
    super.key,
    required this.totalExpenses,
    required this.todayExpenses,
    required this.monthExpenses,
    required this.transactionCount,
    required this.balance, // Thêm vào constructor
  });

  @override
  State<OverviewCard> createState() => _OverviewCardState();
}

class _OverviewCardState extends State<OverviewCard> {
  Weather? weather;
  bool isLoadingWeather = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    try {
      setState(() {
        isLoadingWeather = true;
        errorMessage = null;
      });

      // Try to get weather for current location first
      Weather? currentWeather = await WeatherService.getCurrentLocationWeather();
      
      // If failed, try Ho Chi Minh City as fallback
      if (currentWeather == null) {
        currentWeather = await WeatherService.getWeatherByCity('Ho Chi Minh City');
      }
      
      // If still failed, use mock weather
      currentWeather ??= Weather.getMockWeather();

      if (mounted) {
        setState(() {
          weather = currentWeather;
          isLoadingWeather = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          weather = Weather.getMockWeather(); // Final fallback
          isLoadingWeather = false;
          errorMessage = context.l10n.error;
        });
      }
      logger.e('Error loading weather: $e');
    }
  }

  LinearGradient _getWeatherGradient(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.sunny:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF87CEEB), Color(0xFFFFD700), Color(0xFFFFA500)],
        );
      case WeatherCondition.partlyCloudy:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF87CEEB), Color(0xFFB0C4DE), Color(0xFFFFD700)],
        );
      case WeatherCondition.cloudy:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF778899), Color(0xFF696969), Color(0xFF808080)],
        );
      case WeatherCondition.rainy:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4682B4), Color(0xFF2F4F4F), Color(0xFF1E90FF)],
        );
      case WeatherCondition.stormy:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2F2F2F), Color(0xFF4B0082), Color(0xFF000080)],
        );
      case WeatherCondition.snowy:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE6E6FA), Color(0xFFB0E0E6), Color(0xFFADD8E6)],
        );
      case WeatherCondition.foggy:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFA9A9A9), Color(0xFFD3D3D3), Color(0xFFDCDCDC)],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentWeather = weather ?? Weather.getMockWeather();
    
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: _getWeatherGradient(currentWeather.condition),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.15),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Compact header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.wallet,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.l10n.recent_expenses_card,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildCompactWeatherInfo(currentWeather),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Compact total amount và balance row
              Row(
                children: [
                  // Total expenses
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.arrowTrendDown,
                                color: Colors.white.withOpacity(0.8),
                                size: 16.sp,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                context.l10n.expenses,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            CurrencyFormatter.format(widget.totalExpenses),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Balance
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.wallet,
                                color: Colors.white.withOpacity(0.8),
                                size: 16.sp,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                context.l10n.balance,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            CurrencyFormatter.format(widget.balance),
                            style: TextStyle(
                              color: widget.balance >= 0 ? Colors.white : Colors.red.shade300,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Compact stats row với 3 items
              Row(
                children: [
                  Expanded(
                    child: _buildCompactStatItem(
                      context.l10n.transactions,
                      widget.transactionCount.toString(),
                      FontAwesomeIcons.receipt,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildCompactStatItem(
                      context.l10n.avg_month,
                      CurrencyFormatter.format(widget.totalExpenses / 12),
                      FontAwesomeIcons.calendarDays,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildCompactStatItem(
                      context.l10n.today,
                      CurrencyFormatter.format(widget.todayExpenses),
                      FontAwesomeIcons.clock,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactWeatherInfo(Weather currentWeather) {
    return GestureDetector(
      onTap: _loadWeather,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoadingWeather)
              SizedBox(
                width: 14.w,
                height: 14.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else ...[
              Text(
                currentWeather.emoji,
                style: TextStyle(fontSize: 16.sp),
              ),
              const SizedBox(width: 4),
              Text(
                '${currentWeather.temperature.round()}°C',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompactStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          FaIcon(
            icon,
            color: Colors.white,
            size: 14.sp,
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

}