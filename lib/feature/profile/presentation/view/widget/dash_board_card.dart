import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/profile/data/model/dash_board_model.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class DashboardCard extends StatelessWidget {
  final DashboardModel item;
  const DashboardCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(item.icon, height: 20.h, width: 20.w),
              CustomWidthSpacingWidget(width: 8),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: AppTextStyle.blackPoppinsW500S24.copyWith(
                  fontSize: 21.sp,
                ),
              ),
            ],
          ),
          CustomHeightSpacingWidget(height: 8),
          Text(
            item.subTitle,
            textAlign: TextAlign.center,
            style: AppTextStyle.grey300W400S16.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
          CustomHeightSpacingWidget(height: 16),
          // زرار View details
          GestureDetector(
            onTap: item.onTap,
            child: Container(
              alignment: Alignment.center,
              height: 40.h,
              width: 120.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                LocaleKeys.viewDetails.tr(),
                style: AppTextStyle.whitePoppinsW500S20.copyWith(fontSize: 14),
              ),
            ),
          ),
          CustomHeightSpacingWidget(height: 8),
          Center(
            child: Text(
              item.info,
              textAlign: TextAlign.center,
              style: AppTextStyle.primaryW400S13,
            ),
          ),
        ],
      ),
    );
  }
}
