import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class PopularPlacesTitle extends StatelessWidget {
  const PopularPlacesTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.popularPlaces.tr(),
              style: AppTextStyle.primaryTextW600S22,
            ),
            CustomHeightSpacingWidget(height: 4),
            Text(
              LocaleKeys.distanceCalculation.tr(),
              style: AppTextStyle.secondaryTextW400S17.copyWith(
                color: AppColors.grey200Color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
