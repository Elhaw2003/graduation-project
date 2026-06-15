import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/services/ai_chat_service.dart';
import 'package:smart_guide/core/shared_widgets/custom_bottom_nav_bar.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/aiGuide/presentation/cubit/ai_guide_cubit.dart';
import 'package:smart_guide/feature/aiGuide/presentation/view/ai_guide_screen.dart';
import 'package:smart_guide/feature/explor/presentation/view/explore_ar_spots_screen.dart';
import 'package:smart_guide/feature/guides/presentation/view/choose_guides_screen.dart';
import 'package:smart_guide/feature/home/presentation/home_screen.dart';

class TouristApp extends StatefulWidget {
  const TouristApp({super.key});

  @override
  State<TouristApp> createState() => _TouristAppState();
}

class _TouristAppState extends State<TouristApp> {
  int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      backgroundColor: AppColors.backgroundColor,
      body: IndexedStack(
        index: _bottomNavIndex,
        children: [
          const HomeScreen(),
          const ChooseGuidesScreen(),
          BlocProvider(
            create: (_) => AiGuideCubit(service: AiChatService()),
            child: const AiGuideScreen(),
          ),
          const ExploreArSpotsScreen(),
        ],
      ),
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
