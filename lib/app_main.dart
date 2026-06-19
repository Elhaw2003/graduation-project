import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/di.dart';
import 'package:smart_guide/core/shared_widgets/custom_bottom_nav_bar.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/aiGuide/presentation/cubit/ai_guide_cubit.dart';
import 'package:smart_guide/feature/aiGuide/presentation/view/ai_guide_screen.dart';
import 'package:smart_guide/feature/all_guides/presentation/cubit/tour_guides_cubit.dart';
import 'package:smart_guide/feature/all_guides/presentation/view/all_guides_screen.dart';
import 'package:smart_guide/feature/chat/presentation/cubit/chat_inbox/chat_inbox_cubit.dart';
import 'package:smart_guide/feature/chat/presentation/view/screens/chat_inbox_screen.dart';
import 'package:smart_guide/feature/home/presentation/home_screen.dart';
import 'package:smart_guide/feature/tour_guide_profile/presentation/cubit/save_guides/save_guides_cubit.dart';

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
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<TourGuidesCubit>()),
              BlocProvider(
                create: (_) => sl<SavedGuidesCubit>()..getSavedGuides(),
              ),
            ],
            child: const AllGuidesScreen(),
          ),
          BlocProvider(
            create: (_) => sl<AiGuideCubit>(),
            child: const AiGuideScreen(),
          ),
          BlocProvider(
            create: (_) => sl<ChatInboxCubit>(),
            child: const ChatInboxScreen(),
          ),
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
