import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';
import 'package:smart_guide/core/shared_widgets/custom_text_field_widget.dart';

class CustomContainerForSearchOnly extends StatelessWidget {
  const CustomContainerForSearchOnly({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.all(12.r),
      child: CustomTextFieldWidget(
        suffixIcon: Icons.search,
        suffixColor: AppColors.primaryColor,
        hintTextStyle: TextStyle(
          color: AppColors.secondaryTextColor,
          fontSize: 14.sp,
        ),
        hintText: LocaleKeys.searchDestinationsAndGuides.tr(),
        fillColor: AppColors.backgroundColor.withOpacity(0.5),
      ),
    );
  }
}
