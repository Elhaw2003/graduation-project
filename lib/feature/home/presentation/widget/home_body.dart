import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/core/utils/image_url_extension.dart';
import 'package:smart_guide/core/shared_widgets/custom_grid_view.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/Tour/data/tours/tours_cubit.dart';
import 'package:smart_guide/feature/Tour/views/tour_details_screen.dart';
import 'package:smart_guide/feature/home/presentation/cubit/get_places/get_places_cubit.dart';
import 'package:smart_guide/feature/home/presentation/cubit/get_places/get_places_state.dart';
import 'package:smart_guide/feature/home/presentation/search_screen.dart';
import 'package:smart_guide/feature/home/presentation/widget/custom_home_app_bar.dart';
import 'package:smart_guide/feature/home/presentation/widget/home_search_widget.dart';
import 'package:smart_guide/feature/saved/presentation/cubit/saved_places_cubit.dart';
import 'package:smart_guide/feature/saved/presentation/cubit/saved_places_states.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  String _userName = '';
  String? _profilePic;

  @override
  void initState() {
    super.initState();

    _loadUserData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlacesCubit>().getPlaces();

      context.read<SavedPlacesCubit>().getSavedPlaces();
    });
  }

  Future<void> _loadUserData() async {
    final userName = await SecureStorageHelper.instance.getUserName();
    final profilePic = await SecureStorageHelper.instance.getProfilePic();

    if (!mounted) return;
    setState(() {
      _userName = userName ?? '';
      _profilePic = profilePic;
    });
  }

  Future<void> _onRefresh() async {
    await context.read<PlacesCubit>().refreshPlaces();

    await context.read<SavedPlacesCubit>().getSavedPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SavedPlacesCubit, SavedPlacesState>(
      listener: (context, state) {
        if (state is SavePlaceSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (state is RemovePlaceSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }

        if (state is SavedPlacesFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: RefreshIndicator(
        color: AppColors.primaryColor,
        onRefresh: _onRefresh,
        child: SafeArea(
          top: false,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: FixedAppBarDelegate(
                  child: Container(
                    color: AppColors.backgroundColor,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    alignment: Alignment.bottomCenter,
                    child: CustomHomeAppBar(
                      title: LocaleKeys.hello.tr(),
                      subTitle: _userName.isNotEmpty
                          ? _userName
                          : LocaleKeys.cairoEgypt.tr(),
                      imageUrl: _profilePic?.toHttps(),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      CustomHeightSpacingWidget(height: 20.h),

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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocaleKeys.popularPlaces.tr(),
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          TextButton(
                            onPressed: () {
                              context.pushNamed(AppRoutes.popularPlacesScreen);
                            },
                            child: Text(
                              LocaleKeys.showAll.tr(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      CustomHeightSpacingWidget(height: 10.h),
                    ],
                  ),
                ),
              ),

              BlocBuilder<PlacesCubit, PlacesState>(
                builder: (context, state) {
                  if (state is PlacesLoading) {
                    return const PlacesShimmerGrid();
                  }

                  if (state is PlacesFailure) {
                    return SliverFillRemaining(
                      child: Center(child: Text(state.errorMessage)),
                    );
                  }

                  if (state is PlacesSuccess ||
                      state is PlacesPaginationLoading) {
                    final places = context.read<PlacesCubit>().places;

                    final displayedPlaces = places.take(10).toList();

                    final savedState = context.watch<SavedPlacesCubit>().state;

                    final Set<int> savedIds = savedState is SavedPlacesSuccess
                        ? savedState.savedIds
                        : {};

                    return SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final place = displayedPlaces[index];

                          final isSaved = savedIds.contains(place.id);

                          return CustomGridView(
                            title: place.name,
                            imageUrl: place.imageUrl,
                            rating: place.rating,
                            placeId: place.id.toString(),
                            city: place.city,
                            type: place.type,
                            period: place.period,
                            isSaved: isSaved,
                            onSaveTap: () {
                              final savedCubit = context
                                  .read<SavedPlacesCubit>();

                              if (isSaved) {
                                savedCubit.removePlace(placeId: place.id);
                              } else {
                                savedCubit.savePlace(placeId: place.id);
                              }
                            },
                          );
                        }, childCount: displayedPlaces.length),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15.w,
                          mainAxisSpacing: 15.h,
                          mainAxisExtent: 220.h,
                        ),
                      ),
                    );
                  }

                  return const SliverToBoxAdapter(child: SizedBox());
                },
              ),
       BlocBuilder<ToursCubit, ToursState>(
  builder: (context, state) {
    if (state is ToursLoading) {
      return const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state is ToursFailure) {
      return SliverToBoxAdapter(
        child: Center(child: Text(state.errorMessage)),
      );
    }

    if (state is ToursSuccess) {
      final tours = state.tours;

      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        sliver: SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeightSpacingWidget(height: 20.h),

              Text(
                "Popular Tours",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              CustomHeightSpacingWidget(height: 12.h),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tours.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15.w,
                  mainAxisSpacing: 15.h,
                  mainAxisExtent: 230.h,
                ),
                itemBuilder: (context, index) {
                  final tour = tours[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TourDetailsScreen(tour: tour),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20.r),
                            ),
                            child: Image.network(
                              tour.primaryImage,
                              height: 120.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.all(10.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tour.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 6.h),

                                Row(
                                  children: [
                                    Icon(Icons.schedule, size: 16.sp),
                                    SizedBox(width: 4.w),
                                    Text("${tour.durationHours}h"),
                                  ],
                                ),

                                SizedBox(height: 6.h),

                                Text(
                                  "\$${tour.price}",
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    return const SliverToBoxAdapter(child: SizedBox());
  },
),
            ],
          ),
        ),
      ),
    );
  }
}

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
    return oldDelegate.child != child;
  }
}
