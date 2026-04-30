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
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15.w,
        mainAxisSpacing: 15.h,
        mainAxisExtent: 220.h,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage(Assets.imagesPngFirstSplashScreen),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.r),
                    topRight: Radius.circular(8.r),
                    bottomLeft: Radius.circular(50.r),
                  ),
                ),
              ),
              CustomHeightSpacingWidget(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Great Pyramids of Giza',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.primaryTextW400S16.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                    CustomHeightSpacingWidget(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.starColore,
                          size: 16.sp,
                        ),
                        CustomWidthSpacingWidget(width: 4.w),
                        Text(
                          '4.8',
                          style: AppTextStyle.grey300W400S16.copyWith(
                            fontSize: 12.sp,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.location_on_outlined,
                          color: AppColors.redAppColor,
                          size: 16.sp,
                        ),
                        Text(
                          '4.5 km',
                          style: AppTextStyle.grey300W400S16.copyWith(
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                    CustomHeightSpacingWidget(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Free paid',
                          style: AppTextStyle.grey300W400S16.copyWith(
                            fontSize: 12.sp,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: AppColors.primaryColor,
                          size: 20.sp,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      itemCount: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
