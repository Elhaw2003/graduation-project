// CustomContainerAboutTheGuide.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';

class CustomContainerAboutTheGuide extends StatefulWidget {
  const CustomContainerAboutTheGuide({
    super.key,
    required this.name,
    required this.aboutGuide,
  });
  final String name;
  final String aboutGuide;

  @override
  State<CustomContainerAboutTheGuide> createState() =>
      _CustomContainerAboutTheGuideState();
}

class _CustomContainerAboutTheGuideState
    extends State<CustomContainerAboutTheGuide> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
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
                  'About the Guide',
                  style: AppTextStyle.primaryTextW500S21.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Get to know ${widget.name} and his expertise.',
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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.aboutGuide,
                  style: AppTextStyle.primaryTextW400S16.copyWith(
                    fontSize: 14.sp,
                    height: 1.5,
                  ),
                  maxLines: _isExpanded ? null : 3,
                  overflow: _isExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        _isExpanded ? 'View Less' : 'View More',
                        style: AppTextStyle.primaryW500S20.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: AppColors.primaryColor,
                        size: 20.sp,
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
