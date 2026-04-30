import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
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
      height: 38.h,
      child: ListView.separated(
        separatorBuilder: (context, index) =>
            CustomWidthSpacingWidget(width: 20.w),
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
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.whiteColor,
                // ضفنا الـ Border هنا عشان يحدد الـ unSelected
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.grey200Color, // لون خفيف للحدود
                  width: 1.w,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  filtersNames[index],
                  style: isSelected
                      ? AppTextStyle.whiteW500S17.copyWith(fontSize: 14.sp)
                      : AppTextStyle.black1F2937W400S17.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.primaryColor.withOpacity(
                            0.7,
                          ), // لون النص يتماشى مع الـ border
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
