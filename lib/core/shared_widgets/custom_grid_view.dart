import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/assets.dart';

class CustomGridView extends StatelessWidget {
  const CustomGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 10,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15.w,
            mainAxisSpacing: 15.h,
            // 👈 الـ Ratio هو السر: (العرض / الطول)
            // لو قللت الرقم ده الـ Card هيطول، ولو زودته الـ Card هيقصر
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            return _buildGridItem();
          },
        );
      },
    );
  }

  Widget _buildGridItem() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. الجزء الخاص بالصورة (ياخد مساحة مرنة)
          Expanded(
            flex: 6, // يمثل 60% من طول الـ Card
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage(Assets.imagesPngFirstSplashScreen),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                  bottomLeft: Radius.circular(35.r),
                ),
              ),
            ),
          ),

          // 2. الجزء الخاص بالنصوص (ياخد مساحة مرنة)
          Expanded(
            flex: 5, // يمثل 50% من طول الـ Card عشان يمنع الـ Overflow
            child: Padding(
              padding: EdgeInsets.all(8.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // يوزع العناصر بانتظام
                children: [
                  Text(
                    'Great Pyramids of Giza',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.primaryTextW400S16.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.starColore,
                        size: 14.sp,
                      ),
                      CustomWidthSpacingWidget(width: 4),
                      Text(
                        '4.8',
                        style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.location_on,
                        color: AppColors.redAppColor,
                        size: 14.sp,
                      ),
                      Text(
                        '4.5 km',
                        style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Divider(height: 8, color: Color(0xFFF3F4F6)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Free paid', style: AppTextStyle.primaryW500S16),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.primaryColor,
                        size: 14.sp,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
