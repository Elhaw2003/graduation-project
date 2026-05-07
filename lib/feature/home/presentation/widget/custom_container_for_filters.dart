import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';

class CustomContainerForFilters extends StatefulWidget {
  const CustomContainerForFilters({super.key});
  @override
  State<CustomContainerForFilters> createState() =>
      _CustomContainerForFiltersState();
}

class _CustomContainerForFiltersState extends State<CustomContainerForFilters> {
  final List<String> filtersNames = [
    'All',
    'Nearby',
    'Popular',
    'Guides',
    'Tours',
    'Hotels',
  ];
  int indexSelect = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h, // ارتفاع مرن قليلاً للتابلت
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(width: 12.w),
        scrollDirection: Axis.horizontal,
        itemCount: filtersNames.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          bool isSelected = index == indexSelect;
          return GestureDetector(
            onTap: () => setState(() => indexSelect = index),
            child: AnimatedContainer(
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.whiteColor,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.grey200Color,
                  width: 1.w,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                filtersNames[index],
                style: isSelected
                    ? AppTextStyle.whiteW500S17.copyWith(fontSize: 14.sp)
                    : AppTextStyle.black1F2937W400S17.copyWith(
                        fontSize: 14.sp,
                        color: Colors.grey[700],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
