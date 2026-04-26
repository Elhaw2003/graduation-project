import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';

class TripButtonWidget extends StatelessWidget {
  const TripButtonWidget({
    super.key,
    required this.title,
    required this.colorButton,
    this.onTap,
  });
  final String title;
  final Color colorButton;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        width: 105.w,
        alignment: Alignment.center,
        height: 35.h,
        decoration: BoxDecoration(
          color: colorButton,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Center(
          child: Text(
            title,
            style: AppTextStyle.whiteW500S18.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
