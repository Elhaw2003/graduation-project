import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/assets.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';

class EmptyChatSliver extends StatelessWidget {
  const EmptyChatSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomHeightSpacingWidget(height: 10.h),
            Text(
              LocaleKeys.aiTravelCompanionDescription.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyle.grey300W400S16.copyWith(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
            CustomHeightSpacingWidget(height: 50.h),
            Image.asset(
              Assets.imagesGifAiChat,
              height: 200.h,
              fit: BoxFit.contain,
            ),
            CustomHeightSpacingWidget(height: 40.h),
            Text(
              LocaleKeys.aiGuideDescription.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyle.grey300W400S16.copyWith(
                fontSize: 16.sp,
                height: 1.5,
                color: Colors.grey[500],
              ),
            ),
            CustomHeightSpacingWidget(height: 120.h),
          ],
        ),
      ),
    );
  }
}