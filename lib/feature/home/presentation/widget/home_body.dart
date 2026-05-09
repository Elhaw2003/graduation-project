import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:smart_guide/core/shared_widgets/custom_grid_view.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/home/data/get_places/get_places_cubit.dart';
import 'package:smart_guide/feature/home/data/get_places/get_places_state.dart';
import 'package:smart_guide/feature/home/presentation/place_details_screen.dart';
import 'package:smart_guide/feature/home/presentation/widget/custom_container_for_filters.dart';
import 'package:smart_guide/feature/home/presentation/widget/custom_container_for_search.dart';
import 'package:smart_guide/feature/home/presentation/widget/custom_home_app_bar.dart';
import 'package:smart_guide/feature/home/presentation/widget/custom_section_title_with_action.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدمنا الـ SafeArea بتاعتك لضمان عدم ضرب الـ AppBar
    return SafeArea(
      top: false,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          /// ================= APP BAR (Fixed) =================
          SliverPersistentHeader(
            pinned: true,
            delegate: FixedAppBarDelegate(
              child: Container(
                color: AppColors.backgroundColor,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: Alignment.bottomCenter,
                child: CustomHomeAppBar(
                  title: LocaleKeys.hello.tr(),
                  subTitle: LocaleKeys.cairoEgypt.tr(),
                ),
              ),
            ),
          ),

          /// ================= SEARCH =================
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  CustomHeightSpacingWidget(height: 20.h),
                  // دمجنا الـ onChanged بتاع صاحبك
                  CustomContainerForSearchOnly(
                    onChanged: (value) {
                      context.read<PlacesCubit>().searchPlaces(value);
                    },
                  ),
                  CustomHeightSpacingWidget(height: 15.h),
                ],
              ),
            ),
          ),

          /// ================= STICKY FILTERS =================
          SliverPersistentHeader(
            pinned: true,
            delegate: StickyFiltersHeaderDelegate(
              child: Container(
                color: AppColors.backgroundColor,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                alignment: Alignment.center,
                child: const CustomContainerForFilters(),
              ),
            ),
          ),

          /// ================= CONTENT (BLoC) =================
          // دمجنا الـ BlocBuilder بتاعه اللي بيعرض الداتا من الـ API
          BlocBuilder<PlacesCubit, PlacesState>(
            builder: (context, state) {
              /// ---------- Loading ----------
              if (state is PlacesLoading) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              /// ---------- Error ----------
              if (state is PlacesError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      state.message,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }

              /// ---------- Success ----------
              if (state is PlacesSuccess) {
                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverMainAxisGroup(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            CustomHeightSpacingWidget(height: 10.h),
                            const CustomSectionTitleWithAction(),
                            CustomHeightSpacingWidget(height: 12.h),
                          ],
                        ),
                      ),

                      // الـ Grid بتاعه اللي بيعرض الداتا الحقيقية
                      SliverGrid(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final place = state.places[index];

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PlaceDetailsScreen(id: place.id),
                                ),
                              );
                            },
                            child: CustomGridView(
                              title: place.name,
                              imageUrl: NetworkImage(place.imageUrl),
                              rating: place.rating,
                            ),
                          );
                        }, childCount: state.places.length),
                        // إعدادات الـ Grid اللي كانت عندك
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15.w,
                          mainAxisSpacing: 15.h,
                          mainAxisExtent: 220
                              .h, // أو استخدم childAspectRatio لو حابب تظبطها للتابلت زي ما عملنا قبل كده
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: CustomHeightSpacingWidget(height: 100.h),
                      ),
                    ],
                  ),
                );
              }

              // Default state
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }
}

/// ================= DELEGATES =================
// احتفظت بالـ Delegates بتاعتك لأنها مظبوطة كـ UI أكتر
class FixedAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  FixedAppBarDelegate({required this.child});

  @override
  double get maxExtent => 100.h;

  @override
  double get minExtent => 100.h;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: AppColors.backgroundColor,
      elevation: overlapsContent ? 2 : 0,
      child: SafeArea(bottom: false, child: child),
    );
  }

  @override
  bool shouldRebuild(covariant FixedAppBarDelegate oldDelegate) {
    return false;
  }
}

class StickyFiltersHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  StickyFiltersHeaderDelegate({required this.child});

  @override
  double get maxExtent => 56.h;

  @override
  double get minExtent => 56.h;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      elevation: overlapsContent ? 1 : 0,
      color: AppColors.backgroundColor,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant StickyFiltersHeaderDelegate oldDelegate) {
    return false;
  }
}
