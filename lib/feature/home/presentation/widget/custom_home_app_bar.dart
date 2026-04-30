import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/assets.dart';

class CustomHomeAppBar extends StatelessWidget {
  const CustomHomeAppBar({
    super.key,
    required this.title,
    required this.subTitle,
  });
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.pushNamed(AppRoutes.profileScreen),
          child: Hero(
            // انيميشن انتقال سلس للملف الشخصي
            tag: 'profile_pic',
            child: Container(
              padding: EdgeInsets.all(2.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryColor, width: 2.w),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.r),
                child: Image.asset(
                  Assets.imagesPngSphinx,
                  height: 50.h,
                  width: 50.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: InkWell(
            onTap: () => context.pushNamed(AppRoutes.profileScreen),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyle.thirdTextW900S20.copyWith(
                    fontSize: 18.sp,
                  ),
                ),
                Text(
                  subTitle,
                  style: AppTextStyle.thirdTextW400S17.copyWith(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildSettingsButton(context),
      ],
    );
  }

  Widget _buildSettingsButton(BuildContext context) {
    return TweenAnimationBuilder(
      // انيميشن ظهور خفيف للزرار
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            height: 45.h,
            width: 45.w,
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
            child: IconButton(
              onPressed: () => context.pushNamed(AppRoutes.settingsScreen),
              icon: SvgPicture.asset(
                Assets.imagesSvgSettings,
                height: 22.h,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
