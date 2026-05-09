import 'package:flutter/material.dart';
import 'package:smart_guide/core/shared_widgets/custom_bottom_nav_bar.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/explor/presentation/view/explore_ar_spots_screen.dart';
import 'package:smart_guide/feature/guides/presentation/view/choose_guides_screen.dart';
import 'package:smart_guide/feature/home/presentation/home_screen.dart';

class AppMain extends StatefulWidget {
  const AppMain({super.key});

  @override
  State<AppMain> createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> {
  int _bottomNavIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    ChooseGuidesScreen(),
    Center(child: Text("Ai Chat Screen")),
    ExploreArSpotsScreen(),
    Center(child: Text("More Menu Screen")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // جعلناها false لتجنب الـ Overflow في التابلت وضمان استقرار المحتوى
      extendBody: false,
      backgroundColor: AppColors.backgroundColor,
      // IndexedStack يحافظ على الـ Scroll position لكل صفحة
      body: IndexedStack(index: _bottomNavIndex, children: pages),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}
