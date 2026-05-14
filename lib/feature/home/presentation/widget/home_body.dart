import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_guide/core/shared_widgets/custom_grid_view.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/home/model/place_model.dart';
import 'package:smart_guide/feature/home/presentation/cubit/get_places/get_places_cubit.dart';
import 'package:smart_guide/feature/home/presentation/cubit/get_places/get_places_state.dart';
import 'package:smart_guide/feature/home/presentation/search_screen.dart';
import 'package:smart_guide/feature/home/presentation/widget/custom_home_app_bar.dart';
import 'package:smart_guide/feature/home/presentation/widget/home_search_widget.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late final ScrollController scrollController;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    scrollController.addListener(_paginationListener);

    // جلب البيانات لأول مرة بطريقة آمنة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlacesCubit>().getPlaces();
    });
  }

  void _paginationListener() {
    final cubit = context.read<PlacesCubit>();

    // Pagination Logic: لو وصلنا قبل النهاية بـ 300 بكسل، ومش بنحمل أصلاً
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 300) {
      if (cubit.state is! PlacesPaginationLoading &&
          cubit.state is! PlacesLoading) {
        cubit.getPlaces(loadMore: true);
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: CustomScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          /// ================= APP BAR =================
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

                  /// استخدام הـ Widget بعد التعديل (readOnly)
                  HomeSearchContainer(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SearchPlacesScreen(),
                        ),
                      );
                    },
                  ),

                  CustomHeightSpacingWidget(height: 20.h),
                ],
              ),
            ),
          ),

          /// ================= CONTENT =================
          BlocBuilder<PlacesCubit, PlacesState>(
            builder: (context, state) {
              /// ---------- LOADING (Initial) ----------
              if (state is PlacesLoading) {
                return const PlacesShimmerGrid();
              }

              /// ---------- ERROR ----------
              if (state is PlacesFailure) {
                return SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Text(
                        state.errorMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }

              /// ---------- SUCCESS & PAGINATION ----------
              if (state is PlacesSuccess || state is PlacesPaginationLoading) {
                // نجيب البيانات من الكيوبيت لضمان استمرار عرضها أثناء الباجينيشن
                final places = context.read<PlacesCubit>().places;

                if (places.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No Places Found',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverMainAxisGroup(
                    slivers: [
                      /// GRID
                      SliverGrid(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final place = places[index];
                          return _PlaceItem(place: place);
                        }, childCount: places.length),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15.w,
                          mainAxisSpacing: 15.h,
                          mainAxisExtent: 220.h,
                        ),
                      ),

                      /// PAGINATION LOADING INDICATOR
                      if (state is PlacesPaginationLoading)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),

                      /// BOTTOM SPACE
                      SliverToBoxAdapter(
                        child: CustomHeightSpacingWidget(height: 100.h),
                      ),
                    ],
                  ),
                );
              }

              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }
}

/// =====================================================
/// PLACE ITEM
/// =====================================================

class _PlaceItem extends StatelessWidget {
  const _PlaceItem({required this.place});

  final PlaceModel place;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: () {
        /// NAVIGATION
      },
      child: CustomGridView(
        title: place.name,
        imageUrl: place.imageUrl,
        rating: place.rating,
        placeId: place.id.toString(),
        city: place.city,
        type: place.type,
        period: place.period,
      ),
    );
  }
}

/// =====================================================
/// SHIMMER
/// =====================================================

class PlacesShimmerGrid extends StatelessWidget {
  const PlacesShimmerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          );
        }, childCount: 6),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15.w,
          mainAxisSpacing: 15.h,
          mainAxisExtent: 220.h,
        ),
      ),
    );
  }
}

/// =====================================================
/// APP BAR DELEGATE
/// =====================================================

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
