import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class ApplyReset extends StatelessWidget {
  const ApplyReset({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // زرار Apply
        Expanded(
          // استخدمت Expanded عشان يملوا العرض صح
          child: SizedBox(
            height: 55.h,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                LocaleKeys.apply.tr(),
                style: AppTextStyle.whitePoppinsW500S20,
              ),
            ),
          ),
        ),
        CustomWidthSpacingWidget(width: 16.w),
        // زرار Reset
        Expanded(
          child: SizedBox(
            height: 55.h,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.redColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                LocaleKeys.reset.tr(),
                style: AppTextStyle.whitePoppinsW500S20.copyWith(
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
