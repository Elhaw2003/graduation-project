import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';

// ملحوظة: الاسم CustomGridView ممكن يكون مضلل شوية لأن ده بيعبر عن "كارت واحد" مش Grid كاملة،
// بس هنحافظ عليه زي ما هو عشان منكسرش استدعاءات زميلك في الـ HomeBody
class CustomGridView extends StatelessWidget {
  const CustomGridView({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.rating,
  });

  final String title;
  final ImageProvider imageUrl;
  final dynamic
  rating; // خليناها dynamic عشان لو الـ API رجع int أو double متضربش

  @override
  Widget build(BuildContext context) {
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
            flex: 6, // 60% من الارتفاع للصورة
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageUrl, // 👈 الداتا اللي جاية من زميلك
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
            flex: 5, // 50% من الارتفاع عشان يمنع الـ Overflow
            child: Padding(
              padding: EdgeInsets.all(8.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // يوزع العناصر بانتظام
                children: [
                  Text(
                    title, // 👈 الداتا اللي جاية من زميلك
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
                      CustomWidthSpacingWidget(width: 4.w),
                      Text(
                        rating.toString(), // 👈 الداتا اللي جاية من زميلك
                        style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.location_on,
                        color: AppColors.redAppColor,
                        size: 14.sp,
                      ),
                      Text(
                        '4.5 km', // (ممكن تتعدل لديناميك لو ضفتوها في الـ API)
                        style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Divider(height: 8, color: Color(0xFFF3F4F6)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Free paid',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
