import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/popular_places/presentation/view/widget/filter_sheet/apply_reset.dart';
import 'package:smart_guide/feature/popular_places/presentation/view/widget/filter_sheet/category_chip.dart';
import 'package:smart_guide/feature/popular_places/presentation/view/widget/filter_sheet/distanse_slider.dart';
import 'package:smart_guide/feature/popular_places/presentation/view/widget/filter_sheet/filter_header.dart';
import 'package:smart_guide/feature/popular_places/presentation/view/widget/filter_sheet/location_filter.dart';
import 'package:smart_guide/feature/popular_places/presentation/view/widget/filter_sheet/rating_filter.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(
        left: 23.w,
        right: 23.w,
        top: 16.h,
        bottom: bottomInset > 0 ? bottomInset + 16.h : 16.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // عشان تاخد مساحة المحتوى بس
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الـ Handle اللي فوق
            Center(
              child: Container(
                width: 50.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: AppColors.grey300Color,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            SizedBox(height: 50.h),
            // العناوين (Filter & Reset)
            const FilterHeader(),
            CustomHeightSpacingWidget(height: 25),
            // قسم الموقع (Location)
            LocationFilter(),
            const CustomHeightSpacingWidget(height: 20),
            const CategoryChips(),
            const CustomHeightSpacingWidget(height: 20),
            // قسم المسافة (Distance)
            const DistanceSlider(),
            const CustomHeightSpacingWidget(height: 20),

            // قسم التقييم (Rating)
            const RatingFilter(),
            const CustomHeightSpacingWidget(height: 25),
            // زرار Apply
            ApplyReset(),
          ],
        ),
      ),
    );
  }
}
