import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class FilterHeader extends StatelessWidget {
  const FilterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Text(
            LocaleKeys.filterResults.tr(),
            style: AppTextStyle.primaryTextW500S25,
          ),
        ),
        CustomHeightSpacingWidget(height: 4),
        Text(
          LocaleKeys.filterDescription.tr(),
          style: AppTextStyle.secondaryTextW400S17,
        ),
        CustomHeightSpacingWidget(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 48.w,
              child: Divider(
                color: AppColors.primaryColor.withOpacity(0.3),
                thickness: 1.h,
              ),
            ),
            CustomWidthSpacingWidget(width: 5.w),
            Icon(Icons.star, color: AppColors.primaryColor, size: 12.sp),
            CustomWidthSpacingWidget(width: 5.w),
            SizedBox(
              width: 48.w,
              child: Divider(
                color: AppColors.primaryColor.withOpacity(0.3),
                thickness: 1.h,
                height: 2.h,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
