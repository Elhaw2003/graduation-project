import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_guide/core/services/cache/secure_storage_helper.dart';
import 'package:smart_guide/core/shared_widgets/custom_grid_view.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/auth/domain/user_type_enum.dart';
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
  late final ScrollController scrollController;

  bool isTourist = false;

  @override
  void initState() {
    super.initState();

    _loadUserType();

    scrollController = ScrollController();
    scrollController.addListener(_paginationListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlacesCubit>().getPlaces();

      /// ✅ load saved once
      context.read<SavedPlacesCubit>().getSavedPlaces();
    });
  }

  Future<void> _loadUserType() async {
    final userType = await SecureStorageHelper.instance.getUserType();

    setState(() {
      isTourist =
          userType?.toLowerCase() == UserTypeEnum.Tourist.name.toLowerCase();
    });
  }

  Future<void> _onRefresh() async {
    await context.read<PlacesCubit>().getPlaces();

    await context.read<SavedPlacesCubit>().getSavedPlaces();
  }

  void _paginationListener() {
    final cubit = context.read<PlacesCubit>();

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
    super.dispose();
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
        onRefresh: _onRefresh,
        child: SafeArea(
          top: false,
          child: CustomScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverPersistentHeader(
  pinned: true,
  delegate: FixedAppBarDelegate(
    child: FutureBuilder(
      future: Future.wait([
        SecureStorageHelper.instance.getUserName(),
        SecureStorageHelper.instance.getProfilePic(),
      ]),
      builder: (context, snapshot) {
        final userName = snapshot.data?[0] ?? '';
        final profilePic = snapshot.data?[1];

        return Container(
          color: AppColors.backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          alignment: Alignment.bottomCenter,
          child: CustomHomeAppBar(
            title: userName.isNotEmpty
                ? userName
                : LocaleKeys.hello.tr(),
            subTitle: LocaleKeys.cairoEgypt.tr(),
            imageUrl: profilePic,
          ),
        );
      },
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
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SearchPlacesScreen(),
                            ),
                          );

                          /// ✅ يرجع الهوم الطبيعي بعد البحث
                          context.read<PlacesCubit>().getPlaces();
                        },
                      ),

                      CustomHeightSpacingWidget(height: 20.h),
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

                    final savedState = context.watch<SavedPlacesCubit>().state;

                    final Set<int> savedIds = savedState is SavedPlacesSuccess
                        ? savedState.savedIds
                        : {};

                    return SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final place = places[index];

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
                            isTourist: isTourist,
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
                        }, childCount: places.length),
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
    return false;
  }
}
