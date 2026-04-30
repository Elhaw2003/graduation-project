import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';

class GuideSelectionCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;
  final bool isSvg;

  const GuideSelectionCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
    this.isSvg = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200.w,
        height: 190.h,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isSvg
                ? SvgPicture.asset(
                    iconPath,
                    height: 60.h,
                    colorFilter: ColorFilter.mode(
                      AppColors.primaryColor,
                      BlendMode.srcIn,
                    ),
                  )
                : Image.asset(iconPath, height: 60.h),

            CustomHeightSpacingWidget(height: 20),

            // النص
            Text(
              title,
              style: AppTextStyle.primaryTextW400S16.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryColor,
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
