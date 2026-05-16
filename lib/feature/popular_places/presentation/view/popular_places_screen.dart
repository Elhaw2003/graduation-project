import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/home/presentation/cubit/get_places/get_places_cubit.dart';
import 'package:smart_guide/feature/home/presentation/cubit/get_places/get_places_state.dart';
import 'package:smart_guide/feature/popular_places/presentation/view/widget/popular_places_appbar.dart';
import 'package:smart_guide/feature/popular_places/presentation/view/widget/popular_places_cards.dart';
import 'package:smart_guide/feature/popular_places/presentation/view/widget/popular_places_search_filter.dart';
import 'package:smart_guide/feature/popular_places/presentation/view/widget/popular_places_title.dart';

class PopularPlacesScreen extends StatefulWidget {
  const PopularPlacesScreen({super.key});

  @override
  State<PopularPlacesScreen> createState() => _PopularPlacesScreenState();
}

class _PopularPlacesScreenState extends State<PopularPlacesScreen> {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();

    scrollController.addListener(_paginationListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlacesCubit>().getPlaces();
    });
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

  Future<void> _onRefresh() async {
    await context.read<PlacesCubit>().refreshPlaces();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: true,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primaryColor,
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            // ── SliverAppBar with FlexibleSpaceBar ──
            const PopularPlacesAppbar(),

            // ── Spacing between AppBar and Search ──
            SliverToBoxAdapter(child: SizedBox(height: 10.h)),

            // ── Sticky Search Bar ──
            SliverPersistentHeader(pinned: true, delegate: _SearchDelegate()),

            const PopularPlacesTitle(),

            const PopularPlacesCards(),
          ],
        ),
      ),
    );
  }
}

/// Delegate that keeps the search bar pinned below the SliverAppBar.
/// minExtent == maxExtent prevents the "layoutExtent exceeds paintExtent"
/// assertion error that occurs when they differ.
class _SearchDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 70.h;

  @override
  double get maxExtent => 70.h;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.backgroundColor,
      child: const PopularPlacesSearchFilter(),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
