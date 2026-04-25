import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/my_trips/presentation/view/widget/my_trips/trip_card_item_column.dart';

class TripTypeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final double width;
  final double height;

  const TripTypeCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: height.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.grey200Color, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: TripCardItemColumn(icon: icon, title: title),
      ),
    );
  }
}
