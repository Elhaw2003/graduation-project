import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/monthly_booking_model.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class BookingsBarChart extends StatelessWidget {
  const BookingsBarChart({super.key, required this.bookings});

  final List<MonthlyBookingModel> bookings;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.monthlyBookingsChart.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryTextColor,
            ),
          ),
          SizedBox(height: 8.h),
          _buildLegend(),
          SizedBox(height: 16.h),
          SizedBox(
            height: 200.h,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _calculateMaxY(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _calculateMaxY() / 4,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35.w,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.grey400Color,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= bookings.length) {
                          return const SizedBox.shrink();
                        }
                        final monthIdx = bookings[idx].month - 1;
                        return Padding(
                          padding: EdgeInsets.only(top: 6.h),
                          child: Text(
                            _months[monthIdx.clamp(0, 11)],
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.grey400Color,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: bookings.asMap().entries.map((entry) {
                  final b = entry.value;
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: b.confirmedBookings.toDouble(),
                        color: AppColors.greenColor,
                        width: 12.w,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(4.r),
                        ),
                      ),
                      BarChartRodData(
                        toY: b.cancelledBookings.toDouble(),
                        color: AppColors.redAppColor,
                        width: 12.w,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(4.r),
                        ),
                      ),
                    ],
                  );
                }).toList(),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final label =
                          rodIndex == 0 ? 'Confirmed' : 'Cancelled';
                      return BarTooltipItem(
                        '$label: ${rod.toY.toInt()}',
                        TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11.sp,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        _legendDot(AppColors.greenColor, LocaleKeys.confirmedBookings.tr()),
        SizedBox(width: 16.w),
        _legendDot(AppColors.redAppColor, LocaleKeys.cancelledTours.tr()),
      ],
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.w,
          height: 10.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.grey400Color,
          ),
        ),
      ],
    );
  }

  double _calculateMaxY() {
    if (bookings.isEmpty) return 10;
    final maxVal = bookings
        .map((e) => e.totalBookings)
        .reduce((a, b) => a > b ? a : b);
    return (maxVal * 1.3).ceilToDouble().clamp(5, double.infinity);
  }
}
