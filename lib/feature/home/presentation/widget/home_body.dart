import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_guide/core/routing/app_routes.dart';
import 'package:smart_guide/core/utils/image_url_extension.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/Tour/data/tours/tours_cubit.dart';
import 'package:smart_guide/feature/Tour/views/tour_details_screen.dart';
import 'package:smart_guide/feature/home/data/model/place_model.dart';
import 'package:smart_guide/feature/home/presentation/cubit/get_places/get_places_cubit.dart';
import 'package:smart_guide/feature/home/presentation/cubit/get_places/get_places_state.dart';
import 'package:smart_guide/feature/home/presentation/search_screen.dart';
import 'package:smart_guide/feature/home/presentation/widget/custom_home_app_bar.dart';
import 'package:smart_guide/feature/home/presentation/widget/home_search_widget.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/feature/profile/presentation/cubit/tourist_profile_cubit.dart';
import 'package:smart_guide/feature/profile/presentation/cubit/tourist_session/tourist_session_cubit.dart';
import 'package:smart_guide/feature/profile/presentation/cubit/tourist_session/tourist_session_states.dart';
import 'package:smart_guide/feature/saved/presentation/cubit/saved_places_cubit.dart';
import 'package:smart_guide/feature/saved/presentation/cubit/saved_places_states.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TouristSessionCubit>().loadFromCache();
      context.read<PlacesCubit>().getPlaces();
      context.read<SavedPlacesCubit>().getSavedPlaces();
      _syncProfile();
    });
  }

  Future<void> _syncProfile() async {
    final userId = await SecureStorageHelper.instance.getUserId();
    if (userId == null || userId.isEmpty) return;
    if (!mounted) return;
    await context.read<TouristProfileCubit>().getTouristProfile(id: userId);
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
              backgroundColor: AppColors.greenColor,
            ),
          );
        }
        if (state is RemovePlaceSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.redAppColor,
            ),
          );
        }
        if (state is SavedPlacesFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.redAppColor,
            ),
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
              // ── AppBar ────────────────────────────────────────────────────────
              SliverPersistentHeader(
                pinned: true,
                delegate: FixedAppBarDelegate(
                  child: Container(
                    color: AppColors.backgroundColor,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    alignment: Alignment.bottomCenter,
                    child: BlocBuilder<TouristSessionCubit, TouristSessionState>(
                      builder: (context, sessionState) {
                        final session = sessionState is TouristSessionLoaded
                            ? sessionState
                            : const TouristSessionLoaded(
                                userName: '',
                                profilePic: null,
                                userId: '',
                              );
                        return CustomHomeAppBar(
                          key: ValueKey(
                            '${session.userId}_${session.profilePic ?? session.userName}',
                          ),
                          title: LocaleKeys.hello.tr(),
                          subTitle: session.userName.isNotEmpty
                              ? session.userName
                              : LocaleKeys.tourist.tr(),
                          imageUrl: session.profilePic?.toHttps(),
                          onTap: () async {
                            await context.pushNamed(AppRoutes.profileScreen);
                            if (context.mounted) {
                              context
                                  .read<TouristSessionCubit>()
                                  .loadFromCache();
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),

              // ── Search ────────────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
                  child: HomeSearchContainer(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SearchPlacesScreen(),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Popular Places ────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 28.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.popularPlaces.tr(),
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryTextColor,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Container(
                                width: 36.w,
                                height: 3.h,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF1E3A8A),
                                      Color(0xFF3B82F6),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(2.r),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => context.pushNamed(
                              AppRoutes.popularPlacesScreen,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 7.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                LocaleKeys.showAll.tr(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    BlocBuilder<PlacesCubit, PlacesState>(
                      builder: (context, state) {
                        if (state is PlacesLoading) {
                          return _PlacesShimmer();
                        }
                        if (state is PlacesFailure) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(state.errorMessage),
                          );
                        }
                        if (state is PlacesSuccess ||
                            state is PlacesPaginationLoading) {
                          final places = context
                              .read<PlacesCubit>()
                              .places
                              .take(10)
                              .toList();
                          final savedState = context
                              .watch<SavedPlacesCubit>()
                              .state;
                          final savedIds = savedState is SavedPlacesSuccess
                              ? savedState.savedIds
                              : <int>{};

                          return SizedBox(
                            height: 280.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              itemCount: places.length,
                              itemBuilder: (context, index) {
                                final place = places[index];
                                return _PlaceCard(
                                  place: place,
                                  // index: index,
                                  isSaved: savedIds.contains(place.id),
                                  onSaveTap: () {
                                    final cubit = context
                                        .read<SavedPlacesCubit>();
                                    if (savedIds.contains(place.id)) {
                                      cubit.removePlace(placeId: place.id);
                                    } else {
                                      cubit.savePlace(placeId: place.id);
                                    }
                                  },
                                );
                              },
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                ),
              ),

              // ── Popular Tours ─────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: BlocBuilder<ToursCubit, ToursState>(
                  builder: (context, state) {
                    if (state is ToursLoading) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      );
                    }
                    if (state is ToursFailure) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        child: Text(state.errorMessage),
                      );
                    }
                    if (state is ToursSuccess && state.tours.isNotEmpty) {
                      final tours = state.tours;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 32.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Popular Tours",
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primaryTextColor,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Container(
                                      width: 36.w,
                                      height: 3.h,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF1E3A8A),
                                            Color(0xFF3B82F6),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          2.r,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),
                          SizedBox(
                            height: 220.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              itemCount: tours.length,
                              itemBuilder: (context, index) {
                                final tour = tours[index];
                                return _TourCard(
                                  tour: tour,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          TourDetailsScreen(tour: tour),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 30.h),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Place Card ───────────────────────────────────────────────────────────────

class _PlaceCard extends StatelessWidget {
  final PlaceModel place;
  final bool isSaved;
  final VoidCallback onSaveTap;
  // final int index;
  const _PlaceCard({
    required this.place,
    required this.isSaved,
    required this.onSaveTap,
    // required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        '${AppRoutes.detailsScreen}/${place.id}',
        // extra: resolvePlaceImage(place.imageUrl, index),
      ),
      child: Container(
        width: 185.w,
        margin: EdgeInsets.only(right: 14.w, bottom: 4.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Stack(
            children: [
              // ── Full image ──────────────────────────────────────────────────
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: place.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(color: Colors.white),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.image_not_supported_rounded,
                      size: 36.sp,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),

              // ── Gradient overlay ────────────────────────────────────────────
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.55),
                        Colors.black.withOpacity(0.85),
                      ],
                      stops: const [0.0, 0.45, 0.72, 1.0],
                    ),
                  ),
                ),
              ),

              // ── Type chip top-left ──────────────────────────────────────────
              // if (place.type.isNotEmpty)
              //   Positioned(
              //     top: 12.h,
              //     left: 12.w,
              //     child: Container(
              //       padding: EdgeInsets.symmetric(
              //         horizontal: 10.w,
              //         vertical: 5.h,
              //       ),
              //       decoration: BoxDecoration(
              //         color: Colors.white.withOpacity(0.92),
              //         borderRadius: BorderRadius.circular(20.r),
              //       ),
              //       child: Text(
              //         place.type,
              //         style: TextStyle(
              //           fontSize: 9.sp,
              //           fontWeight: FontWeight.w700,
              //           color: AppColors.primaryColor,
              //         ),
              //       ),
              //     ),
              //   ),

              // ── Bookmark top-right ──────────────────────────────────────────
              Positioned(
                top: 10.h,
                right: 10.w,
                child: GestureDetector(
                  onTap: onSaveTap,
                  child: Container(
                    width: 34.r,
                    height: 34.r,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isSaved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: isSaved ? AppColors.primaryColor : Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
              ),

              // ── Bottom info ─────────────────────────────────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 14.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 11.sp,
                            color: Colors.white70,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              place.city.isNotEmpty
                                  ? place.city
                                  : place.governorate,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 7.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: Colors.amber.withOpacity(0.6),
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  size: 10.sp,
                                  color: Colors.amber,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  place.rating.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.amber,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Tour Card ────────────────────────────────────────────────────────────────

class _TourCard extends StatelessWidget {
  final dynamic tour;
  final VoidCallback onTap;

  const _TourCard({required this.tour, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 230.w,
        margin: EdgeInsets.only(right: 14.w, bottom: 4.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.09),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──────────────────────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: tour.primaryImage ?? '',
                    height: 130.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(height: 130.h, color: Colors.white),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      height: 130.h,
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.broken_image_rounded,
                        size: 32.sp,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  // Duration badge
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 11.sp,
                            color: Colors.white,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            "${tour.durationHours}h",
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Details ────────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.greenColor.withOpacity(0.2),
                              AppColors.greenColor,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          "\$${tour.price}",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Arrow
                      Container(
                        width: 30.r,
                        height: 30.r,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 14.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shimmer ──────────────────────────────────────────────────────────────────

class _PlacesShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 5,
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: 185.w,
            margin: EdgeInsets.only(right: 14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── AppBar delegate ──────────────────────────────────────────────────────────

class PlacesShimmerGrid extends StatelessWidget {
  const PlacesShimmerGrid({super.key});

  @override
  Widget build(BuildContext context) =>
      const SliverToBoxAdapter(child: SizedBox());
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
  bool shouldRebuild(covariant FixedAppBarDelegate oldDelegate) =>
      oldDelegate.child != child;
}
