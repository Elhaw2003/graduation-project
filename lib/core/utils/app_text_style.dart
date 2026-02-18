import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_guide/core/utils/app_colors.dart';

class AppTextStyle {

/// White color

  static TextStyle whiteW600S25 = GoogleFonts.readexPro(
    color: AppColors.whiteEDF0FEColor,
    fontSize: 25.sp,
    fontWeight: FontWeight.w600,
  );
  static TextStyle whiteW500S17 = GoogleFonts.readexPro(
    color: AppColors.whiteEDF0FEColor,
    fontSize: 17.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle whiteW500S27 = GoogleFonts.readexPro(
    color: AppColors.whiteColor,
    fontSize: 27.sp,
    fontWeight: FontWeight.w500,
  );

}
