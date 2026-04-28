import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class FabNewPlaceWidget extends StatelessWidget {
  const FabNewPlaceWidget({super.key, required this.isFabVisible});
  final bool isFabVisible;
  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      offset: isFabVisible ? Offset.zero : const Offset(0, 2),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isFabVisible ? 1.0 : 0.0,
        child: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: AppColors.whiteColor,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          icon: Icon(
            Icons.add_circle_outline,
            color: AppColors.primaryColor,
            size: 26.sp,
          ),
          label: Text(
            LocaleKeys.addNewPlace.tr(),
            style: AppTextStyle.primaryW500S16.copyWith(fontSize: 13.sp),
          ),
        ),
      ),
    );
  }
}
