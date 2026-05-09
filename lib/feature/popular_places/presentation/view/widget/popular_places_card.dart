import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class PopularPlaceCard extends StatelessWidget {
  final String title, rating, category, imageUrl;
 final void Function()? onPressed;
   PopularPlaceCard({
    super.key,
    required this.title,
    required this.rating,

    required this.category,
    required this.imageUrl, this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      height: 180.h,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // الجزء اللي على الشمال: الصورة
          ClipRRect(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(12.r)),
            child: Image.network(
              imageUrl, // استخدم imageUrl بدلاً من image
              // استخدم NetworkImage مؤقتاً للتجربة
              width: 140.w,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // الجزء اللي على اليمين: التفاصيل
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.primary400TextW500S16.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),

                  // التقييم
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(
                        rating,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),

                  // الموقع والمسافة

                  // التصنيف
                  _buildIconText(
                    Icons.castle_outlined,
                    category,
                    color: AppColors.blackColor,
                  ),
                  // زرار View Details
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed:onPressed ,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            LocaleKeys.viewDetails.tr(),
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 12.sp,
                            ),
                          ),
                          CustomWidthSpacingWidget(width: 5.w),
                          const Icon(
                            Icons.arrow_forward,
                            color: AppColors.whiteColor,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ميثود مساعدة لرسم أيقونة جنبها نص
  Widget _buildIconText(IconData icon, String text, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: color ?? Colors.grey),
        SizedBox(width: 6.w),
        Text(
          text,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
        ),
      ],
    );
  }
}
