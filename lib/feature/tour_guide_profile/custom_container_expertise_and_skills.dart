import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/tour_guide_profile/grid_view_for_languages.dart';
import 'package:smart_guide/generated/assets.dart';

class CustomContainerExpertiseAndSkills extends StatelessWidget {
  const CustomContainerExpertiseAndSkills({super.key, required this.languages});
  final List<String> languages;

  final List<String> specialties = const [
    'Ancient History',
    'Photo-Friendly',
    'Hidden Gems',
  ];
  final List<String> icons = const [
    Assets.imagesSvgBank,
    Assets.imagesSvgInstagramLogo,
    Assets.imagesSvgBank,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Expertise & Skills',
                  style: AppTextStyle.primaryTextW500S21.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'What makes me your perfect travel partner...?',
                  style: AppTextStyle.primaryTextW400S14.copyWith(
                    color: AppColors.secondaryTextColor,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.grey200Color, thickness: 1, height: 0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Specialties :',
                  style: AppTextStyle.black1F2937W500S20.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                CustomHeightSpacingWidget(height: 12.h),
                SizedBox(
                  height: 42.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: specialties.length,
                    separatorBuilder: (context, index) => SizedBox(width: 10.w),
                    // itemGroup: (context, index) {
                    //   return CustomButtonWidget(
                    //     buttonWidth: 130.w,
                    //     buttonHeight: 38.h,
                    //     buttonColor: AppColors.primaryColor,
                    //     prefixSvgIcon: icons[index],
                    //     title: specialties[index],
                    //     borderRadiusButton: 8.r,
                    //     titleStyle: AppTextStyle.whiteW500S17.copyWith(
                    //       fontSize: 12.sp,
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   );
                    // },
                    itemBuilder: (context, index) {
                      return CustomButtonWidget(
                        buttonWidth: 130.w,
                        buttonHeight: 38.h,
                        buttonColor: AppColors.primaryColor,
                        prefixSvgIcon: icons[index],
                        title: specialties[index],
                        borderRadiusButton: 8.r,
                        titleStyle: AppTextStyle.whiteW500S17.copyWith(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ),
                CustomHeightSpacingWidget(height: 16.h),
                Text(
                  'Languages :',
                  style: AppTextStyle.black1F2937W500S20.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                CustomHeightSpacingWidget(height: 12.h),
                GridViewForLanguages(languages: languages),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
