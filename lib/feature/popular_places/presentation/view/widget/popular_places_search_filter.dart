import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_text_field_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class PopularPlacesSearchFilter extends StatelessWidget {
  const PopularPlacesSearchFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            Expanded(
              child: CustomTextFieldWidget(
                hintText: LocaleKeys.searchDestinationsAndGuides.tr(),
                prefixIcon: Icons.search,
                prefixColor: AppColors.grey400Color,
              ),
            ),
            CustomWidthSpacingWidget(width: 8.w),
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey200Color),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.tune,
                color: AppColors.primaryColor,
                size: 24.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
