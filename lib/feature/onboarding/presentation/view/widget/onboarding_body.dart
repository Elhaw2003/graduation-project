import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/feature/onboarding/data/list/page_views_screens.dart';
import 'package:smart_guide/feature/onboarding/presentation/view/widget/item_splash_widget.dart';

class OnboardingBody extends StatefulWidget {
  const OnboardingBody({super.key});

  @override
  State<OnboardingBody> createState() => _OnboardingBodyState();
}

class _OnboardingBodyState extends State<OnboardingBody> {
  final PageController controller = PageController();
  int currentIndex = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// الصور فقط
        PageView.builder(
          clipBehavior: Clip.none,
          physics: ClampingScrollPhysics(),
          allowImplicitScrolling: true,
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          itemCount: onboardings.length,
          itemBuilder: (context, index) {
            return Image.asset(
              onboardings[index].image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            );
          },
        ),

        /// المحتوى الثابت
        Positioned(
          bottom: 44.h,
          left: 0,
          right: 0,
          child: ItemOnboardingWidget(
            index: currentIndex,
            controller: controller,
          ),
        ),
      ],
    );
  }
}
