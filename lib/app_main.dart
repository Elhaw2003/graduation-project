import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_guide/core/network/dio_consumer.dart';
import 'package:smart_guide/core/services/ai_chat_service.dart';
import 'package:smart_guide/core/shared_widgets/custom_bottom_nav_bar.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/aiGuide/presentation/cubit/ai_guide_cubit.dart';
import 'package:smart_guide/feature/aiGuide/presentation/view/ai_guide_screen.dart';
import 'package:smart_guide/feature/all_guides/data/repo/tour_guides_repo_imple.dart';
import 'package:smart_guide/feature/all_guides/presentation/cubit/tour_guides_cubit.dart';
import 'package:smart_guide/feature/all_guides/presentation/view/all_guides_screen.dart';
import 'package:smart_guide/feature/explor/presentation/view/explore_ar_spots_screen.dart';
import 'package:smart_guide/feature/guides/presentation/view/choose_guides_screen.dart';
import 'package:smart_guide/feature/home/presentation/home_screen.dart';
import 'package:smart_guide/feature/tour_guide_profile/data/repo/save_guides/save_guides_repo_imple.dart';
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
          // const ChooseGuidesScreen(),
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => TourGuidesCubit(
                  repository: TourGuidesRepositoryImpl(
                    apiConsumer: DioConsumer(dio: Dio()),
                  ),
                ),
              ),
              BlocProvider(
                create: (_) => SavedGuidesCubit(
                  savedGuidesRepository: SavedGuidesRepositoryImpl(
                    apiConsumer: DioConsumer(dio: Dio()),
                  ),
                )..getSavedGuides(),
              ),
            ],
            child: const AllGuidesScreen(),
          ),
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
