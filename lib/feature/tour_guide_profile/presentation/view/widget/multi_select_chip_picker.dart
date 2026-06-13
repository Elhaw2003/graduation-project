import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_button_widget.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class MultiSelectChipPicker extends StatelessWidget {
  const MultiSelectChipPicker({
    super.key,
    required this.label,
    required this.hint,
    required this.options,
    required this.selected,
    required this.onChanged,
    required this.icon,
  });

  final String label;
  final String hint;
  final List<String> options;
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;
  final IconData icon;

  Future<void> _openPicker(BuildContext context) async {
    final tempSelected = List<String>.from(selected);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              constraints: BoxConstraints(maxHeight: 0.75.sh),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 12.h),
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.grey200Color,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
                    child: Row(
                      children: [
                        Icon(icon, color: AppColors.primaryColor, size: 22.sp),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            label,
                            style: AppTextStyle.primaryPoppinsTextW600S18,
                          ),
                        ),
                        Text(
                          '${tempSelected.length}/${options.length}',
                          style: AppTextStyle.grey300W400S16,
                        ),
                      ],
                    ),
                  ),
                  Divider(color: AppColors.grey200Color, height: 1),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16.w),
                      child: Wrap(
                        spacing: 10.w,
                        runSpacing: 10.h,
                        children: options.map((option) {
                          final isSelected = tempSelected.contains(option);
                          return FilterChip(
                            label: Text(option),
                            selected: isSelected,
                            showCheckmark: true,
                            selectedColor:
                                AppColors.primaryColor.withValues(alpha: 0.15),
                            checkmarkColor: AppColors.primaryColor,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : AppColors.secondaryTextColor,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              fontSize: 13.sp,
                            ),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : AppColors.grey200Color,
                            ),
                            onSelected: (value) {
                              setSheetState(() {
                                if (value) {
                                  tempSelected.add(option);
                                } else {
                                  tempSelected.remove(option);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
                    child: CustomButtonWidget(
                      onPressed: () {
                        onChanged(tempSelected);
                        Navigator.pop(sheetContext);
                      },
                      buttonWidth: double.infinity,
                      buttonColor: AppColors.primaryColor,
                      title: LocaleKeys.confirm.tr(),
                      titleStyle: AppTextStyle.backgroundW500S17,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.primaryPoppinsTextW500S15),
        CustomHeightSpacingWidget(height: 8),
        Material(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: () => _openPicker(context),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.grey200Color),
              ),
              child: Row(
                children: [
                  Icon(icon, color: AppColors.primaryColor, size: 20.sp),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: selected.isEmpty
                        ? Text(hint, style: AppTextStyle.grey300W400S16)
                        : Wrap(
                            spacing: 6.w,
                            runSpacing: 6.h,
                            children: selected
                                .map(
                                  (item) => Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.secondaryTextColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
