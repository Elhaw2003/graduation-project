import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_guide/core/shared_widgets/custom_spacing_widget.dart';
import 'package:smart_guide/core/utils/app_colors.dart';
import 'package:smart_guide/core/utils/app_text_style.dart';

class GridViewForLanguages extends StatelessWidget {
  const GridViewForLanguages({super.key, required this.languages});
  final List<String> languages;

  // Static fallback data applied in case the endpoint array is fully empty
  static const List<String> fallbackLanguages = ['English', 'Arabic'];

  @override
  Widget build(BuildContext context) {
    final listToDisplay = languages.isNotEmpty ? languages : fallbackLanguages;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 40.h,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      itemCount: listToDisplay.length,
      itemBuilder: (context, index) {
        final languageName = listToDisplay[index];
        final String lowercaseLang = languageName.toLowerCase();
        
        // Match flag abbreviation to package syntax mapping safely
        String flagCode = 'gb';
        if (lowercaseLang.contains('arab')) flagCode = 'eg';
        if (lowercaseLang.contains('span')) flagCode = 'es';
        if (lowercaseLang.contains('fren')) flagCode = 'fr';
        if (lowercaseLang.contains('germ')) flagCode = 'de';

        return Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'icons/flags/png100px/$flagCode.png',
                package: 'country_icons',
                height: 16.h,
                width: 16.w,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
              CustomWidthSpacingWidget(width: 4.w),
              Flexible(
                child: Text(
                  languageName,
                  style: AppTextStyle.whiteW500S17.copyWith(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              CustomWidthSpacingWidget(width: 2.w),
              ...List.generate(
                5,
                (i) => Icon(
                  Icons.star_sharp,
                  color: AppColors.starColore,
                  size: 10.sp,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}