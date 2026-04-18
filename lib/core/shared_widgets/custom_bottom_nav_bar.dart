import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_svg/svg.dart';
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
      Assets.imagesSvgHomeIcon, // 🔹 أيقونة الصفحة الرئيسية
      Assets.imagesSvgGuidesIcon,
      Assets.imagesSvgRobot,
      Assets.imagesSvgExplorIcon,
      Assets.imagesSvgMoreIcon,
    ];

    final labelList = <String>["Home", "Guides", "Ai Chat", "Explore", "More"];

    final screenWidth = MediaQuery.of(context).size.width;
    const horizontalPadding = 32.0;
    const itemCount = 5;

    final totalWidth = screenWidth - horizontalPadding;
    final itemWidth = totalWidth / itemCount;
    const circleRadius = 30.0;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          height: 85,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              /// الـ Bottom Nav مع بوردر من تحت
              Container(
                height: 75,
                decoration: BoxDecoration(
                  color: AppColors.primaryTextColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16), // 🔹 بوردر من تحت
                    bottomRight: Radius.circular(16), // 🔹 بوردر من تحت
                  ),
                ),
                child: AnimatedBottomNavigationBar.builder(
                  itemCount: iconList.length,
                  height: 75,
                  backgroundColor: Colors
                      .transparent, // 🔹 شفاف عشان الـ Container هو اللي فيه اللون
                  activeIndex: currentIndex,
                  gapLocation: GapLocation.none,
                  splashColor: Colors.transparent,
                  leftCornerRadius:
                      0, // 🔹 صفر عشان الـ Container بيدير البوردر
                  rightCornerRadius:
                      0, // 🔹 صفر عشان الـ Container بيدير البوردر

                  tabBuilder: (int index, bool isActive) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        SvgPicture.asset(
                          iconList[index],
                          width: 24,
                          height: 24,
                          color: isActive
                              ? Colors.transparent
                              : AppColors.whiteColor,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          labelList[index],
                          style: TextStyle(
                            fontSize: 13,
                            color: isActive
                                ? Colors.transparent
                                : AppColors.whiteColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    );
                  },
                  onTap: onTap,
                ),
              ),

              /// الزرار المتحرك
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                bottom: 35,
                left:
                    (itemWidth * currentIndex) + (itemWidth / 2) - circleRadius,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.25),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          iconList[currentIndex], // path أول
                          width: 26,
                          height: 26,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      labelList[currentIndex],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
