import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_guide/core/shared_widgets/custom_arrow_back_button.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/assets.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class PopularPlacesAppbar extends StatelessWidget {
  const PopularPlacesAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      expandedHeight: 120.h,
      collapsedHeight: 60.h,
      backgroundColor: AppColors.backgroundColor,
      surfaceTintColor: Colors.transparent,
      leading: const CustomArrowBackButton(),
      actions: [
        Container(
          width: 40.w,
          height: 40.h,
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          margin: EdgeInsets.only(right: 8.0.w, left: 8.0.w),
          child: SvgPicture.asset(Assets.imagesSvgPopularPlaces),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(left: 56.w, bottom: 16.h),
        title: Text(
          LocaleKeys.popularPlaces.tr(),
          style: AppTextStyle.blackPoppinsW500S24.copyWith(
            fontSize: 18.sp,
          ),
        ),
      ),
    );
  }
}
