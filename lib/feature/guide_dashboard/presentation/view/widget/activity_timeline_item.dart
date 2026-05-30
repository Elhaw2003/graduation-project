import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/guide_dashboard/data/model/recent_activity_model.dart';

class ActivityTimelineItem extends StatelessWidget {
  const ActivityTimelineItem({
    super.key,
    required this.activity,
    required this.isLast,
    required this.index,
  });

  final RecentActivityModel activity;
  final bool isLast;
  final int index;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 80)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline column
            SizedBox(
              width: 40.w,
              child: Column(
                children: [
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: _typeColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _typeIcon,
                      color: _typeColor,
                      size: 18.sp,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2.w,
                        margin: EdgeInsets.symmetric(vertical: 4.h),
                        color: Colors.grey.shade300,
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(width: 12.w),

            // Content
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: _typeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            activity.type,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: _typeColor,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formattedTime,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.grey400Color,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      activity.title,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      activity.description,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.secondaryTextColor,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
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

  IconData get _typeIcon {
    switch (activity.type.toLowerCase()) {
      case 'booking':
        return Icons.calendar_today_outlined;
      case 'review':
        return Icons.star_outline_rounded;
      case 'payout':
        return Icons.account_balance_wallet_outlined;
      case 'cancellation':
        return Icons.cancel_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color get _typeColor {
    switch (activity.type.toLowerCase()) {
      case 'booking':
        return AppColors.primaryColor;
      case 'review':
        return AppColors.starColore;
      case 'payout':
        return AppColors.greenColor;
      case 'cancellation':
        return AppColors.redAppColor;
      default:
        return AppColors.secondaryColor;
    }
  }

  String get _formattedTime {
    final date = activity.parsedDate;
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}
