import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/feature/splash/data/list/page_views_screens.dart';
import 'package:smart_guide/feature/splash/presentation/view/widget/item_splash_widget.dart'
    show ItemSplashWidget;

class SplashBody extends StatefulWidget {
  const SplashBody({super.key});

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody> {
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
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          itemCount: pageViewsScreens.length,
          itemBuilder: (context, index) {
            return Image.asset(
              pageViewsScreens[index].image,
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
          child: ItemSplashWidget(index: currentIndex, controller: controller),
        ),
      ],
    );
  }
}
