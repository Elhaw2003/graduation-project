import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/book_now/data/model/item_booked_model.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';
import '../../../../../core/utils/app_colors.dart';

class ItemBookedWidget extends StatelessWidget {
  const ItemBookedWidget({super.key, required this.itemBookedModel});
  final ItemBookedModel itemBookedModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.sp),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.asset(
              width: 120,
              height: 80,
              itemBookedModel.image,
              fit: BoxFit.fill,
            ),
          ),
          CustomWidthSpacingWidget(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHeightSpacingWidget(height: 10.h),
                Text(
                  itemBookedModel.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.primaryTextW500S17.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
                CustomHeightSpacingWidget(height: 2.h),
                Text(
                  itemBookedModel.subtitle,
                  style: AppTextStyle.grey300W400S16.copyWith(fontSize: 14.sp),
                ),
                CustomHeightSpacingWidget(height: 2),
                RichText(
                  text: TextSpan(
                    style: AppTextStyle.grey300W400S16.copyWith(
                      fontSize: 14.sp,
                    ),
                    children: [
                      TextSpan(text: '${LocaleKeys.expectedPrice.tr()} : '),
                      TextSpan(
                        text: itemBookedModel.price,
                        style: AppTextStyle.greenColorW600S20.copyWith(
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
