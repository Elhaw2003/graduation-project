import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/shared_widgets/custom_bottom_nav_bar.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/chat/data/cubit/chat_cubit.dart';
import 'package:smart_guide/feature/chat/presentation/view/get_all_chats_screen.dart';
import 'package:smart_guide/feature/explor/presentation/view/explore_ar_spots_screen.dart';
import 'package:smart_guide/feature/guides/presentation/view/choose_guides_screen.dart';
import 'package:smart_guide/feature/home/presentation/home_screen.dart';
import 'package:smart_guide/feature/profile/presentation/view/profile_screen.dart';

class TouristApp extends StatefulWidget {
  const TouristApp({super.key});

  @override
  State<TouristApp> createState() => _TouristAppState();
}

class _TouristAppState extends State<TouristApp> {
  int _bottomNavIndex = 0;

  final List<Widget> pages = [
    HomeScreen(),
    ChooseGuidesScreen(),

    // AI Chat Screen
    BlocProvider(
      create: (context) => ChatCubit(),
      child: ChatListScreen(),
    ),
    ExploreArSpotsScreen(),

    // AI Chat Screen
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      backgroundColor: AppColors.backgroundColor,

      // Preserves each page's state across tab switches
      body: IndexedStack(index: _bottomNavIndex, children: pages),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
      ),
    );
  }
}
