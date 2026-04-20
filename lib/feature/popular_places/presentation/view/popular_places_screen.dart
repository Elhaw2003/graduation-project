import 'package:flutter/material.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/popular_places/presentation/view/widget/popular_places_appbar.dart';
import 'package:smart_guide/feature/popular_places/presentation/view/widget/popular_places_cards.dart';
import 'package:smart_guide/feature/popular_places/presentation/view/widget/popular_places_search_filter.dart';
import 'package:smart_guide/feature/popular_places/presentation/view/widget/popular_places_title.dart';

class PopularPlacesScreen extends StatelessWidget {
  const PopularPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // 1. الـ AppBar العلوي
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: const PopularPlacesAppbar(),
          ),
          // 2. شريط البحث والفلتر
          const PopularPlacesSearchFilter(),
          // 3. نصوص العنوان والوصف
          const PopularPlacesTitle(),
          // 4. قائمة الأماكن (The Place Cards)
          const PopularPlacesCards(),
        ],
      ),
    );
  }
}
