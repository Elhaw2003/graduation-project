import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_sliver_appbar_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/saved/data/model/save_placed_card_model.dart';
import 'package:smart_guide/feature/saved/presentation/view/widget/fab_new_place_widget.dart';
import 'package:smart_guide/feature/saved/presentation/view/widget/save_placed_card_list.dart';
import 'package:smart_guide/feature/saved/presentation/view/widget/save_placed_category.dart';
import 'package:smart_guide/generated/assets.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  int _selectedCategoryIndex = 0;
  late ScrollController _scrollController;
  bool _isFabVisible = true;

  // الفئات (أفقية الآن)
  final List<SavedCategoryModel> _categories = const [
    SavedCategoryModel(title: 'Coastal', icon: Icons.beach_access_outlined),
    SavedCategoryModel(title: 'Heritage', icon: Icons.account_balance_outlined),
    SavedCategoryModel(title: 'Historic', icon: Icons.castle_outlined),
    SavedCategoryModel(title: 'Nature', icon: Icons.park_outlined),
    SavedCategoryModel(title: 'Cities', icon: Icons.location_city_outlined),
    SavedCategoryModel(title: 'Activities', icon: Icons.hiking_outlined),
  ];

  // البيانات (أماكن تجريبية)
  final List<SavedPlaceedCardModel> _places = const [
    SavedPlaceedCardModel(
      tag: 'Diving & Nature.',
      title: 'The Blue Hole, Dahab',
      subtitle:
          'A world-renowned diving spot with deep blue waters and vibrant coral reefs.',
      imageUrl: Assets.imagesPngSphinx,
    ),
    SavedPlaceedCardModel(
      tag: 'Luxury & Lifestyle',
      title: 'Abu Tig Marina, El Gouna',
      subtitle:
          'A luxurious waterfront destination featuring upscale dining and stunning yacht views.',
      imageUrl: Assets.imagesPngSphinx,
    ),
    SavedPlaceedCardModel(
      tag: 'Historic Visit',
      title: 'Giza Pyramids',
      subtitle: 'The only remaining wonder of the ancient world.',
      imageUrl: Assets.imagesPngSphinx,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isFabVisible) setState(() => _isFabVisible = false);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isFabVisible) setState(() => _isFabVisible = true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FabNewPlaceWidget(isFabVisible: _isFabVisible),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // 1. AppBar
          CustomSliverAppbarWidget(title: LocaleKeys.savedForLater.tr()),

          // 2. الوصف (يختفي عند السكرول)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(30.w, 12.h, 30.w, 20.h),
              child: Text(
                LocaleKeys.savedDescription.tr(),
                textAlign: TextAlign.center,
                style: AppTextStyle.primaryTextW400S16.copyWith(
                  color: AppColors.grey300Color,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),

          // 3. الـ Sticky Categories (تثبت بالأعلى)
          SavePlacedCategory(
            categories: _categories,
            selectedCategoryIndex: _selectedCategoryIndex,
            onTap: (index) {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
          ),

          SavePlacedCardList(places: _places),
        ],
      ),
    );
  }
}
