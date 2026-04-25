import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';

class TabItemWidget extends StatelessWidget {
  const TabItemWidget({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.icon,
  });
  final String title;
  final IconData icon;
  final bool isSelected;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            border: isSelected ? null : Border.all(color: Colors.grey[300]!),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 25.sp,
                  color: isSelected
                      ? AppColors.secondaryColor
                      : AppColors.secondaryTextColor,
                ),
                CustomWidthSpacingWidget(width: 5),
                Text(
                  title,
                  style: isSelected
                      ? AppTextStyle.secondaryColorW400S13.copyWith(
                          fontSize: 20.sp,
                        )
                      : AppTextStyle.secondaryTextW400S17.copyWith(
                          fontSize: 20.sp,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
