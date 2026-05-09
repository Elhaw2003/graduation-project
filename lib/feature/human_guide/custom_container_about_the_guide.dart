import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';

class CustomContainerAboutTheGuide extends StatelessWidget {
  const CustomContainerAboutTheGuide({super.key, required this.name, required this.aboutGuide});
  final String name;
  final String aboutGuide;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0.w),
      height: 197.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
            minVerticalPadding: 0,

            title: Text('About the Guide'),
            subtitle: Text('Get to know $name and his expertise.'),
            titleTextStyle: AppTextStyle.primaryTextW500S21,
            subtitleTextStyle: AppTextStyle.primaryTextW400S14.copyWith(
              fontSize: 12.sp,
            ),
          ),
          Divider(
            color: AppColors.grey400Color,
            thickness: .5,
            endIndent: 16,
            indent: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              aboutGuide,
              style: AppTextStyle.primaryTextW400S16,
            ),
          ),
        ],
      ),
    );
  }
}
