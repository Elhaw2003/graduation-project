import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/feature/saved/data/model/save_placed_card_model.dart';

class CategoryChipSaved extends StatelessWidget {
  const CategoryChipSaved({
    super.key,
    required this.savedCategoryModel,
    required this.selected,
    this.onTap,
  });
  final SavedCategoryModel savedCategoryModel;
  final bool selected;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryColor : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: selected ? AppColors.primaryColor : AppColors.grey200Color,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              savedCategoryModel.icon,
              color: selected ? AppColors.whiteColor : AppColors.grey300Color,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              savedCategoryModel.title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                color: selected ? AppColors.whiteColor : AppColors.grey300Color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
