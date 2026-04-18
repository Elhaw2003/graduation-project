import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/guides/presentation/view/widgets/grid_view_for_languages.dart';
import 'package:smart_guide/generated/assets.dart';

class CustomContainerExpertiseAndSkills extends StatelessWidget {
  const CustomContainerExpertiseAndSkills({super.key});
  final List<String> specialties = const [
    'Ancient History',
    'Museum Tours',
    'Photo-Friendly',
  ];
  final List<String> icons = const [
    Assets.imagesSvgInstagramLogo,
    Assets.imagesSvgBank,
    Assets.imagesSvgBank,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 350.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.whiteColor,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                minVerticalPadding: 0,
                title: Text(
                  'Expertise & Skills',
                  style: AppTextStyle.primaryTextW500S21.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'What makes me your perfect travel partner ..?',
                  style: AppTextStyle.primaryTextW400S14.copyWith(
                    fontSize: 12.sp,
                  ),
                ),
              ),
              Divider(color: AppColors.grey400Color, thickness: .5),
              Text(
                'Specialties :',
                style: AppTextStyle.black1F2937W500S20.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              CustomHeightSpacingWidget(height: 8),
              SizedBox(
                height: 40.h, // مهم جداً عشان يدي ارتفاع ثابت
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: specialties.length,
                  separatorBuilder: (context, index) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) {
                    return CustomButtonWidget(
                      buttonWidth: 137.w,
                      buttonHeight: 32.h,
                      buttonColor: AppColors.primaryColor,
                      prefixSvgIcon: icons[index],
                      title: specialties[index],
                      titleStyle: AppTextStyle.whiteW500S17.copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    );
                  },
                ),
              ),
              CustomHeightSpacingWidget(height: 10),
              Text(
                'Languages :',
                style: AppTextStyle.black1F2937W500S20.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              GridViewForLanguages(),
            ],
          ),
        ),
      ),
    );
  }
}
