import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/saved/data/model/save_placed_card_model.dart';
import 'package:smart_guide/feature/saved/presentation/view/widget/category_chip_saved.dart';

class SavePlacedCategory extends StatelessWidget {
  const SavePlacedCategory({
    super.key,
    required this.categories,
    required this.onTap,
    required this.selectedCategoryIndex,
  });
  final List<SavedCategoryModel> categories;
  final ValueChanged<int> onTap;
  final int selectedCategoryIndex;
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _StickyCategoryDelegate(
        child: Container(
          color: AppColors.backgroundColor,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: CategoryChipSaved(
                  savedCategoryModel: categories[index],
                  selected: index == selectedCategoryIndex,
                  onTap: () => onTap(index),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Sticky header delegate for pinned category bar
class _StickyCategoryDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _StickyCategoryDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 65.h;
  @override
  double get minExtent => 65.h;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
