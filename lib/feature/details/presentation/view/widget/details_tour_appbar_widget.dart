import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/details/presentation/view/widget/details_top_button_widget.dart';
import 'package:smart_guide/generated/assets.dart';

class DetailsTourAppbarWidget extends StatelessWidget {
  const DetailsTourAppbarWidget({
    super.key,
    required this.headerAnimationController,
    required this.scrollOffset,
  });

  final AnimationController headerAnimationController;
  final double scrollOffset;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 60.h,
      expandedHeight: 280.h,
      pinned: true,
      stretch: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.primaryColor,
      surfaceTintColor: Colors.transparent,

      // أزرار الرجوع والبوكمارك
      leading: DetailsTopButtonWidget(
        icon: Icons.arrow_back,
        onTap: () => Navigator.pop(context),
      ),
      actions: [
        DetailsTopButtonWidget(
          icon: Icons.bookmark_border_rounded,
          onTap: () {},
        ),
        SizedBox(width: 8.w),
      ],

      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(Assets.imagesPngFirstSplashScreen, fit: BoxFit.cover),

            // 2. تدرج لوني عشان الكلام يظهر (Gradient Overlay)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),

            // 3. البيانات (الاسم، الموقع، التقييم)
            Positioned(
              bottom: 20.h,
              left: 20.w,
              right: 20.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Great Pyramids of Giza",
                    style: AppTextStyle.whitePoppinsW500S24.copyWith(
                      fontSize: 20.sp,
                    ),
                  ),
                  Text(
                    "The final resting place\nof Egypt's greatest Pharaohs",
                    style: AppTextStyle.whitePoppinsW400S16,
                    textAlign: TextAlign.center,
                  ),
                  CustomHeightSpacingWidget(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white70,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "West Bank, Luxor",
                        style: AppTextStyle.whitePoppinsW400S16.copyWith(
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(
                        "4.9",
                        style: AppTextStyle.whitePoppinsW400S16.copyWith(
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
