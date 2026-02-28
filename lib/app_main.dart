import 'package:flutter/material.dart';
import 'package:smart_guide/core/shared_widgets/custom_bottom_nav_bar.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
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
    Center(child: Text("Chat")),
    Center(child: Text("Explore")),
    Center(child: Text("Menu")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.backgroundColor,
      body: pages[_bottomNavIndex],

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}
