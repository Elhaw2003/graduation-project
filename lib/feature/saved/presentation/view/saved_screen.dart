import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_sliver_appbar_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/feature/saved/presentation/cubit/saved_places_cubit.dart';
import 'package:smart_guide/feature/saved/presentation/cubit/saved_places_states.dart';
import 'package:smart_guide/feature/saved/presentation/view/widget/fab_new_place_widget.dart';
import 'package:smart_guide/feature/saved/presentation/view/widget/save_placed_card_list.dart';
import 'package:smart_guide/feature/saved/presentation/view/widget/save_placed_category.dart';
import 'package:smart_guide/feature/saved/data/model/save_placed_card_model.dart';
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

  final List<SavedCategoryModel> _categories = const [
    SavedCategoryModel(title: 'Coastal', icon: Icons.beach_access_outlined),
    SavedCategoryModel(title: 'Heritage', icon: Icons.account_balance_outlined),
    SavedCategoryModel(title: 'Historic', icon: Icons.castle_outlined),
    SavedCategoryModel(title: 'Nature', icon: Icons.park_outlined),
    SavedCategoryModel(title: 'Cities', icon: Icons.location_city_outlined),
    SavedCategoryModel(title: 'Activities', icon: Icons.hiking_outlined),
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SavedPlacesCubit>().getSavedPlaces();
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
      // floatingActionButton: FabNewPlaceWidget(isFabVisible: _isFabVisible),
      body: BlocListener<SavedPlacesCubit, SavedPlacesState>(
        listener: (context, state) {
          if (state is RemovePlaceSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: BlocBuilder<SavedPlacesCubit, SavedPlacesState>(
          builder: (context, state) {
            if (state is SavedPlacesLoading) {
              return Scaffold(
                backgroundColor: AppColors.backgroundColor,
                body: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
              );
            }

            List<SavedPlaceedCardModel> places = [];
            if (state is SavedPlacesSuccess) {
              places = state.places
                  .map((p) => SavedPlaceedCardModel.fromPlaceModel(p))
                  .toList();
            }

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                CustomSliverAppbarWidget(title: LocaleKeys.savedForLater.tr()),
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
                // SavePlacedCategory(
                //   categories: _categories,
                //   selectedCategoryIndex: _selectedCategoryIndex,
                //   onTap: (index) {
                //     setState(() {
                //       _selectedCategoryIndex = index;
                //     });
                //   },
                // ),
                SavePlacedCardList(places: places),
              ],
            );
          },
        ),
      ),
    );
  }
}
