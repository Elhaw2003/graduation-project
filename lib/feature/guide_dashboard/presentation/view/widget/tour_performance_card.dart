import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/tour_performance_model.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class TourPerformanceCard extends StatelessWidget {
  const TourPerformanceCard({
    super.key,
    required this.tour,
    required this.index,
  });

  final TourPerformanceModel tour;
  final int index;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(40 * (1 - value), 0),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.tour_outlined,
                    color: AppColors.primaryColor,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    tour.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTextColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            SizedBox(height: 14.h),

            // Stats row
            Row(
              children: [
                _metricChip(
                  icon: Icons.confirmation_num_outlined,
                  label: LocaleKeys.dashboardTotalBookings.tr(),
                  value: tour.totalBookings.toString(),
                  color: AppColors.primaryColor,
                ),
                SizedBox(width: 8.w),
                _metricChip(
                  icon: Icons.attach_money,
                  label: LocaleKeys.dashboardRevenue.tr(),
                  value: '\$${tour.revenue.toStringAsFixed(0)}',
                  color: AppColors.greenColor,
                ),
              ],
            ),

            SizedBox(height: 10.h),

            // Occupancy rate bar
            Row(
              children: [
                Text(
                  LocaleKeys.occupancyRate.tr(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.secondaryTextColor,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6.r),
                    child: LinearProgressIndicator(
                      value: (tour.occupancyRate / 100).clamp(0.0, 1.0),
                      minHeight: 8.h,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _occupancyColor(tour.occupancyRate),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  '${tour.occupancyRate.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: _occupancyColor(tour.occupancyRate),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.sp, color: color),
            SizedBox(width: 6.w),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: AppColors.grey400Color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _occupancyColor(double rate) {
    if (rate >= 75) return AppColors.greenColor;
    if (rate >= 40) return Colors.orange;
    return AppColors.redAppColor;
  }
}
