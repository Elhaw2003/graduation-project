import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_grid_view.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/home/presentation/widget/custom_container_for_filters.dart';
import 'package:smart_guide/feature/home/presentation/widget/custom_container_for_search.dart';
import 'package:smart_guide/feature/home/presentation/widget/custom_home_app_bar.dart';
import 'package:smart_guide/feature/home/presentation/widget/custom_section_title_with_action.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // 1. الـ AppBar الثابت في سقف الشاشة
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

        // 2. الـ Search (يختفي مع السكرول)
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                CustomHeightSpacingWidget(height: 25.h),
                const CustomContainerForSearchOnly(),
                CustomHeightSpacingWidget(height: 15.h),
              ],
            ),
          ),
        ),

        // 3. الـ Filters الثابتة (تخبط تحت الـ AppBar)
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

        // 4. المحتوى (العناوين والـ Grid)
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              CustomHeightSpacingWidget(height: 10.h),
              const CustomSectionTitleWithAction(),
              // CustomHeightSpacingWidget(height: 12.h),
              const CustomGridView(),
              CustomHeightSpacingWidget(height: 100.h),
            ]),
          ),
        ),
      ],
    );
  }
}

// Delegate للـ AppBar الثابت
class FixedAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  FixedAppBarDelegate({required this.child});

  @override
  double get maxExtent => 110.h; // مساحة كافية للـ Status bar والـ AppBar
  @override
  double get minExtent => 110.h;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant FixedAppBarDelegate oldDelegate) => false;
}

// Delegate للفلاتر الثابتة
class StickyFiltersHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  StickyFiltersHeaderDelegate({required this.child});

  @override
  double get maxExtent => 54.h;
  @override
  double get minExtent => 54.h;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      elevation: overlapsContent ? 2 : 0, // ظل خفيف لما تخبط تحت الـ AppBar
      color: AppColors.backgroundColor,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant StickyFiltersHeaderDelegate oldDelegate) => true;
}
