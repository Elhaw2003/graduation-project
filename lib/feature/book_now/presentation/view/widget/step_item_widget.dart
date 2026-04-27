import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/assets.dart';

class StepItemWidget extends StatelessWidget {
  const StepItemWidget({
    super.key,
    required this.active,
    required this.label,
    required this.index,
  });
  final bool active;
  final String label;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: BoxBorder.all(
              width: 1.5.w,
              color: active
                  ? AppColors.secondaryColor
                  : AppColors.secondaryColor.withValues(alpha: 0.5),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: active
                ? AppColors.secondaryColor
                : Colors.transparent,
            child: Text(
              '$index',
              style: active
                  ? AppTextStyle.whitePoppinsW400S16
                  : AppTextStyle.whiteW500S17.copyWith(
                      color: AppColors.grey300Color,
                    ),
            ),
          ),
        ),
        CustomHeightSpacingWidget(height: 5),
        Opacity(
          opacity: active ? 1 : 0.5.w,
          child: SvgPicture.asset(
            Assets.imagesSvgArrowBottom,
            width: 11.w,
            height: 11.h,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: active
                ? AppColors.secondaryColor
                : AppColors.secondaryColor.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 5),
                blurRadius: 5.r,
                spreadRadius: 0,
                color: Colors.white.withOpacity(0.2),
              ),
            ],
          ),
          child: Text(
            label,
            style: active
                ? AppTextStyle.whiteW500S17.copyWith(fontSize: 12.sp)
                : AppTextStyle.whiteW500S17.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.whiteColor.withValues(alpha: 0.7),
                  ),
          ),
        ),
      ],
    );
  }
}
