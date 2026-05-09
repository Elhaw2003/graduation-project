import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/details/presentation/view/widget/details_tour_title_text_widget.dart';

class DetailsTourAboutTitle extends StatelessWidget {
  const DetailsTourAboutTitle({
    super.key,
    required this.sectionSlideAnimations,
    required this.sectionFadeAnimations,
  });
  final List<Animation<Offset>> sectionSlideAnimations;
  final List<Animation<double>> sectionFadeAnimations;
  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: sectionSlideAnimations[2],
      child: FadeTransition(
        opacity: sectionFadeAnimations[2],
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.greyCFC9C9olor, width: 1.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailsTourTitleTextWidget(text: "About Valley of the Kings"),
              SizedBox(height: 14.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                child: Text(
                  "The Valley of the Kings is one of Egypt's most iconic archaeological sites, serving as the royal necropolis during the New Kingdom. Located on the Nile's west bank near Luxor, this majestic valley contains over 60 royal tombs, including the world-famous tomb of Tutankhamun.",
                  style: AppTextStyle.primaryTextW400S16.copyWith(
                    fontSize: 12.sp,
                    height: 1.7.h,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                child: Text(
                  "Visitors can explore these ancient chambers to experience the beautifully preserved wall paintings and hieroglyphics that depict the journey to the afterlife.",
                  style: AppTextStyle.primaryTextW400S16.copyWith(
                    fontSize: 12.sp,
                    height: 1.7.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
