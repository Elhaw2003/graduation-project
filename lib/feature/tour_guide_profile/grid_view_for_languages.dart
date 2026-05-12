// GridViewForLanguages.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';

class GridViewForLanguages extends StatelessWidget {
  const GridViewForLanguages({super.key});
  final List<String> languages = const ['English', 'Spanish', 'French'];
  final List<String> flags = const ['gb', 'es', 'fr'];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 40.h,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      itemCount: languages.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'icons/flags/png100px/${flags[index]}.png',
                package: 'country_icons',
                height: 16.h,
                width: 16.w,
              ),
              CustomWidthSpacingWidget(width: 4.w),
              Flexible(
                child: Text(
                  languages[index],
                  style: AppTextStyle.whiteW500S17.copyWith(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              CustomWidthSpacingWidget(width: 2.w),
              ...List.generate(
                4,
                (i) => Icon(
                  Icons.star_sharp,
                  color: AppColors.starColore,
                  size: 12.sp,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
