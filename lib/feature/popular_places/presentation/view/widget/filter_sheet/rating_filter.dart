import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class RatingFilter extends StatelessWidget {
  const RatingFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.rating.tr(),
          style: AppTextStyle.primaryPoppinsTextW600S18,
        ),
        const CustomHeightSpacingWidget(height: 12),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          height: 70.h, // ارتفاع مناسب للـ Row
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            // بنبدأ من 5 وننزل لـ 1 عشان الترتيب المنطقي (أو العكس حسب تصميمك)
            itemBuilder: (context, index) {
              int ratingValue = index + 1; // لأن index بيبدأ من 0
              return RatingItem(rating: ratingValue);
            },
          ),
        ),
      ],
    );
  }
}

class RatingItem extends StatelessWidget {
  final int rating; // عدد النجوم اللي هتكون صفراء

  const RatingItem({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 12.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor, // لون خلفية خفيف
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.grey200Color),
      ),
      child: Row(
        children: List.generate(5, (starIndex) {
          return Icon(
            starIndex < rating ? Icons.star : Icons.star_border,
            // 👈 السحر هنا: لو رقم النجمة أقل من التقييم المطلوب تتلون أصفر
            color: AppColors.starColore,
            size: 18.sp,
          );
        }),
      ),
    );
  }
}
