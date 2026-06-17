import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';

class BlockedBanner extends StatelessWidget {
  const BlockedBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.redAppColor.withOpacity(0.08),
        border: Border(
          top: BorderSide(
            color: AppColors.redAppColor.withOpacity(0.3),
            width: 1.2,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.block_rounded, color: AppColors.redAppColor, size: 20.sp),
            SizedBox(width: 10.w),
            Text(
              'This conversation is blocked.',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.redAppColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
