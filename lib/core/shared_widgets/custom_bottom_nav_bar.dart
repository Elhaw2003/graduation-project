import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/generated/assets.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconList = <String>[
      Assets.imagesSvgHomeIcon,
      Assets.imagesSvgGuidesIcon,
      Assets.imagesSvgRobot,
      Assets.imagesSvgArrowSend,
    ];

    final labelList = <String>["Home", "Guides", "AI Guide", "Chat"];

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double availableWidth = constraints.maxWidth - 32.w;
          double itemWidth = availableWidth / iconList.length;
          double circleRadius = 28.r;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: SizedBox(
              height: 85.h,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  /// Background Container (The NavBar Body)
                  Container(
                    height: 70.h,
                    decoration: BoxDecoration(
                      color: AppColors.primaryTextColor,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: AnimatedBottomNavigationBar.builder(
                      itemCount: iconList.length,
                      height: 70.h,
                      backgroundColor: Colors.transparent,
                      activeIndex: currentIndex,
                      gapLocation: GapLocation.none,
                      splashColor: Colors.transparent,
                      tabBuilder: (int index, bool isActive) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomHeightSpacingWidget(height: 15),
                            Opacity(
                              opacity: isActive ? 0 : 1,
                              child: SvgPicture.asset(
                                iconList[index],
                                width: 22.w,
                                height: 22.h,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.whiteColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            CustomHeightSpacingWidget(height: 4),
                            Opacity(
                              opacity: isActive ? 0 : 1,
                              child: Text(
                                labelList[index],
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      onTap: onTap,
                    ),
                  ),

                  /// Floating Active Indicator (The Moving Circle)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOutCubic,
                    bottom: 25.h,
                    left: (itemWidth * currentIndex) +
                        (itemWidth / 2) -
                        circleRadius,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 56.r,
                          width: 56.r,
                          decoration: BoxDecoration(
                            color: currentIndex == 2
                                ? AppColors.primaryColor
                                : Colors.blueAccent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (currentIndex == 2
                                        ? AppColors.primaryColor
                                        : Colors.blueAccent)
                                    .withOpacity(0.45),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              iconList[currentIndex],
                              width: 24.w,
                              height: 24.h,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          labelList[currentIndex],
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
