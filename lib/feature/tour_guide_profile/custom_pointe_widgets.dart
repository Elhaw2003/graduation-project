// CustomPointe.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';

class CustomPointe extends StatelessWidget {
  const CustomPointe({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(6.0.r),
      child: Container(
        height: 6.h,
        width: 6.w,
        decoration: BoxDecoration(
          color: AppColors.primaryTextColor,
          borderRadius: BorderRadius.circular(3.r),
        ),
      ),
    );
  }
}
