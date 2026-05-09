import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/assets.dart';

class DetailsTourMustSeeWidget extends StatelessWidget {
  const DetailsTourMustSeeWidget({
    super.key,
    required this.sectionSlideAnimations,
    required this.sectionFadeAnimations,
  });

  final List<Animation<Offset>> sectionSlideAnimations;
  final List<Animation<double>> sectionFadeAnimations;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: sectionSlideAnimations[1],
      child: FadeTransition(
        opacity: sectionFadeAnimations[1],
        child: Container(
          width: double.infinity,
          height: 200.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(8.r), // خليت الـ radius متناسق
            border: Border.all(color: AppColors.greyCFC9C9olor, width: 1.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Must-See Tombs",
                style: AppTextStyle.primaryTextW400S15.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 14.h),

              // 👈 التعديل السحري هنا: استخدمنا Expanded عشان الـ ListView ميعملش Crash
              Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 3,
                  separatorBuilder: (context, index) =>
                      SizedBox(width: 12.w), // مسافة بين الكروت
                  itemBuilder: (context, index) => _buildTombCard(index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTombCard(int index) {
    final titles = ["Tutankhamun's Tomb", "Ramses II Tomb", "KV9 Tomb"];
    final images = [
      Assets.imagesPngPyramids,
      Assets.imagesPngSphinx,
      Assets.imagesPngPyramids,
    ];

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 800 + (index * 200)),
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: Container(
              width: 140.w,
              // شيلنا الـ height الثابت من هنا لأن الـ Expanded هيظبطه تلقائي
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                image: DecorationImage(
                  image: AssetImage(images[index]),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  ),
                ),
                child: Text(
                  titles[index],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
