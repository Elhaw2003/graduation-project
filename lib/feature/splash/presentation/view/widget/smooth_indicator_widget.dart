import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/splash/data/list/page_views_screens.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SmoothIndicatorWidget extends StatelessWidget {
  const SmoothIndicatorWidget({super.key, required this.controller});
  final PageController controller;
  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: controller,
      count: pageViewsScreens.length,
      axisDirection: Axis.horizontal,
      effect: SlideEffect(
        spacing: 10.0.w,
        radius: 10.0.r,
        dotWidth: 120.w,
        dotHeight: 4.0.h,
        paintStyle: PaintingStyle.fill,
        strokeWidth: 1.5,
        dotColor: AppColors.whiteEDF0FEColor.withValues(alpha: 0.5),
        activeDotColor: AppColors.whiteColor,
      ),
    );
  }
}
